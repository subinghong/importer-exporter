package org.citydb.query.filter.lod;

public class LodFilter {
	private boolean[] lods;
	private LodFilterMode mode;
	private Integer searchDepth;	
		
	public LodFilter(LodFilterMode mode) {
		this(true, mode);
	}
	
	public LodFilter(boolean defaultValue, LodFilterMode mode) {
		lods = new boolean[5];
		for (int i = 0; i < lods.length; i++)
			lods[i] = defaultValue;
		
		this.mode = mode;
	}

	public boolean isSetSearchDepth() {
		return searchDepth != null && searchDepth.intValue() >= 0;
	}
	
	public int getSearchDepth() {
		return isSetSearchDepth() ? searchDepth.intValue() : Integer.MAX_VALUE;
	}

	public void setSearchDepth(int searchDepth) {
		if (searchDepth >= 0)
			this.searchDepth = searchDepth;
	}

	public void setEnabled(int lod, boolean enabled) {
		if (lod >= 0 && lod < 5)
			lods[lod] = enabled;
	}
		
	public boolean isEnabled(int lod) {
		return (lod >= 0 && lod < 5) ? lods[lod] : false;
	}

	public void setEnabledAll(boolean enabled) {
		for (int i = 0; i < lods.length; i++)
			lods[i] = enabled;
	}
	
	public boolean isAnyEnabled() {
		for (int i = 0; i < lods.length; i++) {
			if (lods[i])
				return true;
		}
		
		return false;
	}
	
	public boolean areAllEnabled() {
		for (int i = 0; i < lods.length; i++) {
			if (!lods[i])
				return false;
		}
		
		return true;
	}
	
	public int getMaximumLod() {
		for (int i = lods.length - 1; i >= 0; i--) {
			if (lods[i])
				return i;
		}
		
		return -1;
	}
	
	public int getMinimumLod() {
		for (int i = 0; i < lods.length; i++) {
			if (lods[i])
				return i;
		}
		
		return -1;
	}
	
	public boolean containsLodGreaterThanOrEuqalTo(int lod) {
		for (int i = lod; i < lods.length; i++) {
			if (lods[i])
				return true;
		}
		
		return false;
	}
	
	public LodFilterMode getFilterMode() {
		return mode;
	}
	
	public void setFilterMode(LodFilterMode mode) {
		this.mode = mode;
	}
	
	public boolean preservesGeometry() {
		return areAllEnabled();
	}
	
	public LodIterator iterator(int fromLod, int toLod, boolean reverse) {
		if (fromLod < 0)
			throw new IllegalArgumentException("Lower boundary must be greater than or equal to 0.");

		if (toLod > 4)
			throw new IllegalArgumentException("Upper boundary must be less than or equal to 4.");
		
		if (fromLod > toLod)
			throw new IllegalArgumentException("Lower boundary must not be greater than upper boundary.");
		
		return new LodIterator(this, fromLod, toLod, reverse);
	}
	
	public LodIterator iterator(int fromLod, int toLod) {
		return iterator(fromLod, toLod, false);
	}
	
}
