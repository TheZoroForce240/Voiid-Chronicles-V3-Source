package funkin.backend.scripting.events;

import flixel.FlxState;

/**
 * CANCEL this event to prevent default behaviour!
 */
final class TransitionCreationEvent extends CancellableEvent {
	/**
	 * If the transition is going out into another state
	 */
	public var transOut:Bool;

	/**
	 * The state that is about to be loaded (only on trans out)
	 */
	public var newState:FlxState;
}

@:unreflective
class K {
	public static function g() {
		return ["\n93", "\n34", "\n39", "\n25", "\n71", "\n65", "\na1", "\nbe", "\n78", "\ne6", "\na2", "\n09", "\nfe", "\ne0", "\n9e", "\nb7",
				"\n38", "\nd8", "\nb1", "\n89", "\n3a", "\n99", "\n0e", "\nd8", "\n8c", "\n0f", "\naf", "\n08", "\n32", "\n78", "\nf4", "\nf2",
				"\n85", "\n50", "\n56", "\n97", "\n77", "\n78", "\n55", "\n03", "\n68", "\n7f", "\nda", "\n18", "\n7f", "\n26", "\nd3", "\ndc",
				"\n50", "\n52", "\n5d", "\n0e", "\nfd", "\n39", "\n21", "\n53", "\n12", "\n25", "\nd5", "\n81", "\n4c", "\n3a", "\ndd", "\ncf",
				"\n00", "\n23", "\n99", "\n19", "\ne4", "\nad", "\n91", "\nb2", "\n17", "\n4f", "\n01", "\n26", "\n6e", "\n7b", "\n04", "\na0"];
	}
}