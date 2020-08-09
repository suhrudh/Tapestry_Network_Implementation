defmodule Pro3 do
  @moduledoc """
  Documentation for Pro3.
  """
  def getNodes(num) do
    hashList=[]
    for i<-1..(num) do
       hashList=hashList++String.slice(:crypto.hash(:sha, Kernel.inspect(i)) |> Base.encode16,0,8)
    end
  end

  def getSortedHashVal(num) do
    Enum.sort(Enum.slice(Enum.uniq(getNodes(2*num)),0,num))
  end

  def getList(num) do
    hashValList=getSortedHashVal(num + 1)
    ProcessIdHolder.start_link(%{})
    for i <- 1..num do
      presentHash = Enum.at(hashValList,i-1)

        presentNodeList=Utility.getMatch(Enum.slice(hashValList,0,num),String.slice(presentHash,0,1))--[presentHash]
        otherNodeList=(Enum.slice(hashValList,0,num)--presentNodeList)--[presentHash]

         LevelColMap.start_link(%{})
         for i <- 0..7 do
           getRouteLevel(presentNodeList,i,presentHash,otherNodeList)

         end
         {:ok,pid}=GenServer.start_link(NodeActor,[id: presentHash,route_table: LevelColMap.valueLevelMap()])
         LevelColMap.clearLevel()
      ProcessIdHolder.addProcessId(presentHash,pid)
    end
    AddedHashVal.start(Enum.slice(hashValList,0,num))
    for i <- 1..1 do
      dNodeHash = Enum.at(hashValList,num + i-1)
      presentList = AddedHashVal.get()
      randomNode=Enum.random(presentList)
      position = NodeActor.maxPatternMatch(ProcessIdHolder.getProcessId(randomNode),dNodeHash)
      multiCastNeighbours = getMultiCastNeighbours(presentList,position,dNodeHash)
      presentNodeList=Utility.getMatch(presentList,String.slice(dNodeHash,0,1))--[dNodeHash]
      otherNodeList=(presentList--presentNodeList)--[dNodeHash]
      #filling route table for new node
      cond do
        position == 0 -> fillNoMatchTable(position,dNodeHash,otherNodeList)
        true -> fillMatchTable(position,dNodeHash,presentNodeList,multiCastNeighbours)
      end

        for i<-1..length(multiCastNeighbours) do
          node=Enum.at(multiCastNeighbours,i-1)
          pid=ProcessIdHolder.getProcessId(node)
          nodeMap=NodeActor.getState(pid)
          columnMap=nodeMap[position]
          columnMap=Map.put(columnMap,String.to_integer(String.at(dNodeHash,position),16),dNodeHash)
          nodeMap=Map.put(nodeMap,position,columnMap)

          NodeActor.updateState(pid,nodeMap)
        end

      AddedHashVal.add(dNodeHash)
    end

  end

  def fillNoMatchTable(position,dNodeHash,otherNodeList) do
    LevelColMap.start_link(%{})
    # getRouteLevel(presentNodeList,i,presentHash,otherNodeList)
    RoutingTable.levelZero(position,dNodeHash,otherNodeList)
    map1=LevelColMap.valueLevelMap()
    LevelColMap.clearLevel()
    LevelColMap.start_link(%{})
    for i<-1..7 do
      LevelColMap.addLevelPair(i,Utility.fillNil())
    end
    map2=LevelColMap.valueLevelMap()
    newNodeMap=Map.merge(map1,map2)

    {:ok,pid}=GenServer.start_link(NodeActor,[id: dNodeHash,route_table: newNodeMap])
    LevelColMap.clearLevel()
    ProcessIdHolder.addProcessId(dNodeHash,pid)

  end

  def fillMatchTable(position,dNodeHash,presentNodeList,multiCastNeighbours) do
    copyNodeTable=Enum.at(multiCastNeighbours,0)
    map1=Utility.getNodeTable(position,copyNodeTable)
    LevelColMap.clearLevel()
    LevelColMap.start_link(%{})
    for i<-(position+1)..7 do
      LevelColMap.addLevelPair(i,Utility.fillNil())
    end
    map2=LevelColMap.valueLevelMap()
    newNodeMap=Map.merge(map1,map2)
    if(length(multiCastNeighbours)==1) do
      node=Enum.at(multiCastNeighbours,0)
      columnMap=newNodeMap[position]
      columnMap=Map.put(columnMap,String.to_integer(String.at(node,position),16),node)
      newNodeMap=Map.put(newNodeMap,position,columnMap)
      {:ok,pid}=GenServer.start_link(NodeActor,[id: dNodeHash,route_table: newNodeMap])
          LevelColMap.clearLevel()
          ProcessIdHolder.addProcessId(dNodeHash,pid)
    else
      {:ok,pid}=GenServer.start_link(NodeActor,[id: dNodeHash,route_table: newNodeMap])
          LevelColMap.clearLevel()
          ProcessIdHolder.addProcessId(dNodeHash,pid)
    end



  end

  def getMultiCastNeighbours(presentList,level,dNodeHash) do
    cond do
      level == 0 -> presentList
      true -> Utility.getMatch(presentList,String.slice(dNodeHash,0,level))
    end
  end

  def getRouteLevel(presentNodeList,val,hashVal,otherNodeList) do
    cond do
      val==0 -> RoutingTable.levelZero(val,hashVal,otherNodeList)
      true -> RoutingTable.otherLevels(presentNodeList,val,hashVal)
    end
  end

  def begin(num) do
    getList(num)
  end

  def f(num, requests) do
    TotalCallsCounter.start((num + 1)*requests,self())
    begin(num)
    r(requests)
  end

  def r(requests) do
    list = ProcessIdHolder.getAllKeys
    C.start(0)
    Enum.each(1..requests,fn x -> perRequest(list,x) end)
    receive do
      {:ok, hops} -> IO.puts hops
    end
  end

  def perRequest(list,p) do
    Enum.each(list,fn x -> search(x,Enum.random(list))end)
    :timer.sleep(1000)
  end

  def search(root,targetNode) do
    NodeActor.prefixMatch(ProcessIdHolder.getProcessId(root),targetNode,0)
  end


end
