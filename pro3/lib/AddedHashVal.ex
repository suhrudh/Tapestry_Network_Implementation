defmodule AddedHashVal do
  use Agent

  def start(list) do
    Agent.start_link(fn ->  list end, name: :addedHashVal)
  end

  def add(elem) do
    Agent.update(:addedHashVal,fn x -> x ++ [elem] end)
  end

  def get() do
    Agent.get(:addedHashVal, fn x -> x end)
  end

end
