module GraphToRosetree exposing (..)

import GraphTypes exposing (GraphContent, NodesAndConnections, Node, NodesList, Connection, ConnectionsList)
import Tree exposing (Tree)

import Uuid
import List
import NativeTypes exposing(Native(..))

type alias TreeItemFromNode = 
  {
    uuid: Uuid.Uuid
  , name: String
  , content: Native--GraphContent
  }

type alias TreeFromNodes = Tree TreeItemFromNode

-- TODO find root based on node that has no connections to it
getRoot: NodesAndConnections -> Maybe Node
getRoot nodesAndConnections = 
  let 
    nodesList = nodesAndConnections.nodes
    svgItemList = List.filter (\treeItemFromNode -> treeItemFromNode.content == Svg) nodesList
  in 
    List.head svgItemList

-- for now better to use uuid instead of Node, because of maybe hell in graphToTreeRecursiveHelper
-- getConnectionsFromNode: Node -> ConnectionsList -> ConnectionsList
-- getConnectionsFromNode node connections = 
--   List.filter (\connection -> connection.from == node.uuid) connections
getConnectionsFromUuid: Uuid.Uuid -> ConnectionsList -> ConnectionsList
getConnectionsFromUuid uuid connections = 
  List.filter (\connection -> connection.from == uuid) connections

-- TODO what to do with unfound nodes. How to communicate this back to the user
getNodeFromConnection: Connection -> NodesList -> Maybe Node
getNodeFromConnection connection nodes = 
  let
    uuid = connection.to
    nodeList = List.filter (\node -> node.uuid == uuid) nodes  
  in
    List.head nodeList

treeItemFromNodeAndConnection: Node -> Connection -> TreeItemFromNode
treeItemFromNodeAndConnection node connection =
  {
    uuid = node.uuid
  , name = connection.name
  , content = node.content
  }

graphToTree: NodesAndConnections -> Maybe TreeFromNodes
graphToTree nodesAndConnections =
  let
    maybeRoot = getRoot nodesAndConnections
    -- maybeRootContent = 
    --   case maybeRoot of 
    --     Just root ->
    --       Just 
    --         (TreeItemFromNode 
    --           root.uuid
    --          "root_svg"
    --           Svg
    --         )
    --     Nothing -> Nothing
    -- fake connection to make tree
    maybeFakeConnection = 
      case maybeRoot of 
        Nothing ->
          Nothing
        Just root ->
          Just {
            to = root.uuid
          , from = root.uuid
          , name = "root"
          }
  in
    -- case maybeRootContent of
    --   Just rootContent ->
    --     Just (Tree.singleton rootContent)
    --   Nothing ->
    --     Nothing
    case maybeFakeConnection of 
      Nothing ->
        Nothing
      Just connection ->
        graphToTreeRecursiveHelper connection nodesAndConnections

graphToTreeRecursiveHelper: Connection -> NodesAndConnections -> Maybe TreeFromNodes
graphToTreeRecursiveHelper connection nodesAndConnections =
  let
    maybeNode = getNodeFromConnection connection nodesAndConnections.nodes
    maybeCurrentItem = 
      case maybeNode of
        Nothing -> Nothing
        Just node ->
           Just {
            uuid = node.uuid
          , name = connection.name
          , content = node.content--GraphContent
          }
    currentChildrenConnections = getConnectionsFromUuid connection.to nodesAndConnections.connections
    maybeTreeChildren = List.map (\conn -> (graphToTreeRecursiveHelper conn nodesAndConnections)) currentChildrenConnections
    treeChildren = List.filterMap (\maybeTreeChild->maybeTreeChild) maybeTreeChildren
  in
    case maybeCurrentItem of
      Nothing -> Nothing
      Just currentItem -> 
        Just (Tree.tree currentItem treeChildren)

  