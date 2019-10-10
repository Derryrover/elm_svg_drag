module IdRoseTreeUpdate exposing (..)

-- core
import List

-- selfmade packages
import Tree
import Tree.Zipper
import IdWrapper
import IdRoseTree
import SvgElement
import IdRoseTreeDisplay

update : (aMsg -> aModel -> (aModel, Cmd aMsg))
  -> IdRoseTreeDisplay.Msg aMsg aModel
  -> IdRoseTree.Model aModel 
  -> ( IdRoseTree.Model aModel,  Cmd (IdRoseTreeDisplay.Msg aMsg aModel))
update itemUpdateFunc msg model = 
  case msg of
    IdRoseTreeDisplay.Direction id itemMsg ->
      let (res, cmd) = updateHelperRoseTree itemUpdateFunc id itemMsg model  
      in (res, Cmd.map (IdRoseTreeDisplay.Direction id) cmd)
    IdRoseTreeDisplay.New id -> --todo
      (model, Cmd.none)
    IdRoseTreeDisplay.CreatedRandom idParent newId -> --todo
      (model, Cmd.none)

updateHelperRoseTree :  (aMsg -> aModel -> (aModel, Cmd aMsg)) 
  -> IdWrapper.Id
  -> aMsg
  -> IdRoseTree.Model aModel 
  -> ( IdRoseTree.Model aModel, Cmd aMsg)
updateHelperRoseTree itemUpdateFunc id msg tree = 
  let 
    testFunc = (\idItem -> (IdWrapper.getId idItem) == id)
    zipper = Tree.Zipper.fromTree tree
    maybeZipperOnTarget = Tree.Zipper.findFromRoot testFunc zipper
  in 
    case maybeZipperOnTarget of
      Nothing ->
        (tree, Cmd.none)
      Just zipperOnTarget ->
        let
          idItem = Tree.Zipper.label zipperOnTarget
          itemModel = IdWrapper.getItem idItem
          itemId = IdWrapper.getId idItem
          (updatedItemModel, cmd) = itemUpdateFunc msg itemModel
          updatedZipper = Tree.Zipper.replaceLabel (IdWrapper.Wrapper itemId updatedItemModel) zipperOnTarget
          updatedTree = Tree.Zipper.toTree updatedZipper
        in
          (updatedTree, cmd)
        


  
