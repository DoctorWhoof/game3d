Class SceneTreeView Extends TreeView
	
	Method Refresh( scene:Scene )
		RootNode.RemoveAllChildren()	'clear tree
		RootNode.Text = "Scene"
		RootNode.Expanded = True
		For Local e:= EachIn scene.GetRootEntities()
			AddToTree( e, RootNode )
		Next
		
		NodeClicked = Lambda( node:TreeView.Node )
			Print( node.Text + " selected" )
		End
	End 
	
	
	Private
	Method AddToTree( e:Entity, parent:TreeView.Node )
		Local node:=New TreeView.Node( e.Name, parent )
		node.Expanded = True
		
		For Local c := Eachin e.Children
			AddToTree( c, node )
		Next
	End
	
End

