defmodule ProcessIdHolder do
use Agent

  def start_link(val) do
    Agent.start_link(fn -> val end, name: :processmap)
  end

  def getProcessId(key) do
    Agent.get(:processmap,& Map.fetch!(&1,key))
  end

  def addProcessId(key,val) do
    Agent.update(:processmap,&(Map.put_new(&1,key,val)))
  end

  def getAllKeys() do
    Agent.get(:processmap, & Map.keys(&1))
  end

  def value() do
    Agent.get(:processmap, & &1)
  end

end
