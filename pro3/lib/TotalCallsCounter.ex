defmodule TotalCallsCounter do
  use Agent

  def start(totalCalls,processid) do
    Agent.start_link(fn-> [tc: totalCalls,count: 0,pid: processid] end, name: :totalCallsCounter)
  end

  def increaseCount() do
    Agent.update(:totalCallsCounter,fn x -> [tc: x[:tc],count: x[:count]+1,pid: x[:pid]] end)
  end

  def get() do
    Agent.get(:totalCallsCounter, fn x -> x end)
  end

end
