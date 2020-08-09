defmodule NodeActor do
  use GenServer

  def start_link(__MODULE__,state) do
    GenServer.start_link(__MODULE__,state,state)

  end

  def init(state) do
    {:ok,state}
  end

  def getState(pid) do
      GenServer.call(pid,:get)
  end

  def handle_call(:get,_from,state) do
    {:reply,state[:route_table],state}
  end

  def updateState(pid,updatedMap) do
      GenServer.call(pid,{:update,updatedMap})
  end

  def handle_call({:update,updatedMap},_from,state) do
      # state[:route_table]=updatedMap
      # {:noreply,[id: state[:id],route_table: updatedMap]}
       {:reply,state,[id: state[:id],route_table: updatedMap]}
  end


  def prefixMatch(pid,targetNode,hopNumber) do
    GenServer. cast(pid,{:prefix_match,targetNode,hopNumber})
  end

  def handle_cast({:prefix_match,targetNode,hopNumber},state) do
    cond do
      targetNode != state[:id] -> prefixProcessing(targetNode,state,hopNumber)
      true -> hopEndProcessing(hopNumber,state[:id])
    end

    {:noreply,state}
  end

  def hopEndProcessing(hopNumber,id) do
    TotalCallsCounter.increaseCount()
    countState = TotalCallsCounter.get()
    C.storeMax(hopNumber)
    cond do
      countState[:tc] == countState[:count] -> send(countState[:pid],{:ok,C.get()})
      true -> false
    end
  end

  def prefixProcessing(targetNode,state,hopNumber) do
    level = Utility.prefixMatchLevel(state[:id],targetNode)
    {nextDigit, ""} = Integer.parse(String.at(targetNode,level),16)
    nextHop = state[:route_table][level][nextDigit]
    if(nextHop == nil) do
      IO.puts("state------")
      IO.inspect(state)
      IO.puts("target node --#{targetNode}")
    end
    pid = ProcessIdHolder.getProcessId(nextHop)
    prefixMatch(pid, targetNode,hopNumber+1)
end

  def maxPatternMatch(pid,target) do
    GenServer.call(pid,{:max_pattern_match,target})
  end

  def handle_call({:max_pattern_match,targetNode},_from,state) do
    level = Utility.prefixMatchLevel(state[:id],targetNode)
    {nextDigit, ""} = Integer.parse(String.at(targetNode,level),16)
    nextHop = state[:route_table][level][nextDigit]
    cond do
      nextHop == nil -> {:reply,level,state}
      true -> {:reply,nextHopNonNilCase(nextHop, targetNode),state}
    end
  end

  def nextHopNonNilCase(nextHop,targetNode) do
    pid = ProcessIdHolder.getProcessId(nextHop)
    maxPatternMatch(pid,targetNode)
  end

end
