defmodule ColMap do
  use Agent

    def start(value) do
      Agent.start_link(fn->value end, name: :colMap)
    end

    def addCol(key,val) do
      Agent.update(:colMap,&(Map.put_new(&1,key,val)))
    end

    def getAllColumnVal() do
      Agent.get(:colMap, & Map.values(&1))
    end

    def getAllColumns() do
      Agent.get(:colMap, & Map.keys(&1))
    end

    def clearCol() do
      Agent.update(:colMap, fn x->%{} end)
    end

    def value() do
      Agent.get(:colMap, & &1)
    end

end
