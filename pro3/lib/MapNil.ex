defmodule MapNil do
use Agent

  def start_link(val) do
    Agent.start_link(fn -> val end, name: :mapnil)
  end

  def getMapVal(key) do
    Agent.get(:mapnil,& Map.fetch!(&1,key))
  end

  def addMapVal(key,val) do
    Agent.update(:mapnil,&(Map.put_new(&1,key,val)))
  end

  def getAllKeys() do
    Agent.get(:mapnil, & Map.keys(&1))
  end

  def clearMap() do
    Agent.update(:mapnil, fn x->%{} end)
  end

  def mapValue() do
    Agent.get(:mapnil, & &1)
  end

end
