defmodule C do
  use Agent

  def start(value) do
    Agent.start_link(fn-> value end, name: :maxHop)
  end

  def storeMax(value) do
    Agent.update(:maxHop,fn x -> max(x,value) end)
  end

  def get() do
    Agent.get(:maxHop, fn x -> x end)
  end

end
