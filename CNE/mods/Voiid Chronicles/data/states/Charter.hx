import funkin.editors.ui.UIContextMenu.UIContextMenuOptionSpr;
import funkin.editors.ui.UISubstateWindow;
import funkin.editors.ui.UIText;
import funkin.editors.ui.UINumericStepper;
import funkin.editors.ui.UIButton;
import funkin.editors.charter.Charter;
import funkin.editors.ui.UIContextMenu;

function postCreate()
{
	updateFolderFromSong(Charter.__song);
}