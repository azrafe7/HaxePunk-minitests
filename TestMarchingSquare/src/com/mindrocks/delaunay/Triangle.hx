package com.mindrocks.delaunay;

using com.mindrocks.delaunay.ArrayHelper;


class Triangle {
	private var _sites:Array<Site>;
	public var sites(get, null) : Array<Site>;
	inline public function get_sites():Array<Site> {
		return _sites;
	}
	
	inline public function Triangle(a:Site, b:Site, c:Site) {
//		_sites = new Array<Site>([ a, b, c ]);
		_sites = [a, b, c];
	}
	
	inline public function dispose():Void {
		_sites.clear();
		_sites = null;
	}

}
