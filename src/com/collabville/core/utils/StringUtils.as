package com.collabville.core.utils
{
	public class StringUtils
	{
		public static var formatRE:RegExp = /(\{[^\}^\{]+\})/g;
		public static var trimRE:RegExp = /^\s*|\s*$/g;
		public static var quoteRE:RegExp = /["\\\x00-\x1f\x7f-\x9f]/g;
		
		public static function stringFormat ( format:String, ...args):String {
			return format.replace(formatRE, formatMethod);
		}
		
		public static function trim ( value:String ):String {
			return value.replace(trimRE, '');
		}
		
		private static function formatMethod ( str:String, m:String, index:int, completeString:String ):String {
			var	index:int = parseInt(m.substr(1), 10);
			var value:* = args[index];
			if (value === null || typeof(value) == 'undefined') {
				return '';
			}
			return value.toString();
		}
	}
}