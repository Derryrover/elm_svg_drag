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
  , content: GraphContent
  }

type TreeFromNodes = Tree TreeItemFromNode

-- TODO find root based on node that has no connections to it
getRoot: NodesAndConnections -> Maybe Node
getRoot nodesAndConnections = 
  let 
    nodesList = nodesAndConnections.nodes
    svgItemList = List.filter (\treeItemFromNode -> treeItemFromNode.content == Svg) nodesList
  in 
    List.head svgItemList


getConnectionsFromNode: Node -> ConnectionsList -> ConnectionsList
getConnectionsFromNode node connections = 
  List.filter (\connection -> connection.from == node.uuid) connections
