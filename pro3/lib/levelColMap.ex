defmodule LevelColMap do
  use Agent
  def start_link(value) do
    Agent.start_link(fn -> value end,name: :levelMap)
  end

  def start(value) do
    Agent.start_link(fn->value end, name: :colMap)
  end

  def addLevel(key) do
    Agent.update(:levelMap,&(Map.put_new(&1,key,value())))
  end

  def addLevelPair(key,val) do
    Agent.update(:levelMap,&(Map.put_new(&1,key,val)))
  end


  def addCol(key,val) do
    Agent.update(:colMap,&(Map.put_new(&1,key,val)))
  end

  def value() do
    Agent.get(:colMap, & &1)
  end

  def valueLevelMap() do
    Agent.get(:levelMap, & &1)
  end

  def clearCol() do
    Agent.update(:colMap, fn x->%{} end)
  end

  def clearLevel() do
    Agent.update(:levelMap, fn x->%{} end)
  end

end
