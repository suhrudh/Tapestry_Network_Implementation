defmodule Utility do
  # Input is a sorted list
  def getMatch(nodelist,strmatch) do
    Enum.filter(nodelist, fn x-> String.slice(x,0,String.length(strmatch))==strmatch end)
  end

  def prefixMatchLevel(s1,s2) do
      Enum.find_index(0..7,fn x -> String.at(s1,x) != String.at(s2,x) end)
  end

  def fillNil() do
    MapNil.start_link(%{})
    for i<-0..15 do
      MapNil.addMapVal(i,nil)
    end
    MapNil.mapValue()
  end

  def getNodeTable(position,copyNodeTable) do
    pid = ProcessIdHolder.getProcessId(copyNodeTable)
    existingNodeMap=NodeActor.getState(pid)
    LevelColMap.start_link(%{})
    for i <- 0..position do
      LevelColMap.addLevelPair(i,existingNodeMap[i])
    end
    LevelColMap.valueLevelMap()
  end

end
