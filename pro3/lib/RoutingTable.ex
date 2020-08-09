defmodule RoutingTable do

  def levelZero(val,hashVal,otherNodeList) do

    LevelColMap.start(%{})
    for i<-0..15 do
      iList=Enum.filter(otherNodeList,fn x->String.slice(x,val,val+1)==Integer.to_string(i,16) end)

      if(length(iList)>0) do

        LevelColMap.addCol(i,Enum.at(iList,0))
      else
        LevelColMap.addCol(i,nil)
      end
    end
    LevelColMap.addLevel(val)
    LevelColMap.clearCol()
  end

  def otherLevels(presentNodeList,val,hashVal) do

    LevelColMap.start(%{})
    excludeNextLevelPrefix=Utility.getMatch(presentNodeList,String.slice(hashVal,0,val))--Utility.getMatch(presentNodeList,String.slice(hashVal,0,val+1))

    for i<-0..15 do
      iList=Enum.filter(excludeNextLevelPrefix,fn x->String.slice(x,val,1)==Integer.to_string(i,16) end)

      if(length(iList)>0) do
        LevelColMap.addCol(i,Enum.at(iList,0))
      else
        LevelColMap.addCol(i,nil)
      end
    end
    LevelColMap.addLevel(val)
    LevelColMap.clearCol()

  end



end
