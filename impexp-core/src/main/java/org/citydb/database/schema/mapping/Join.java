package org.citydb.database.schema.mapping;

import java.util.ArrayList;
import java.util.List;

import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;

@XmlType(name = "join", propOrder = {
    "conditions",
    "treeHierarchy"
})
public class Join extends AbstractJoin {
	@XmlElement(name="condition")
    protected List<Condition> conditions;
    protected TreeHierarchy treeHierarchy;
    @XmlAttribute(required = true)
    protected String table;
    @XmlAttribute(required = true)
    protected String fromColumn;
    @XmlAttribute(required = true)
    protected String toColumn;
    @XmlAttribute(required = true)
    protected TableRole toRole;
    
    protected Join() {
    	conditions = new ArrayList<>();
    }
    
    public Join(String table, String fromColumn, String toColumn, TableRole toRole) {
    	this();
    	this.table = table;
    	this.fromColumn = fromColumn;
    	this.toColumn = toColumn;
    	this.toRole = toRole;
    }

    public List<Condition> getConditions() {
    	return new ArrayList<>(conditions);
    }

    public boolean isSetConditions() {
        return conditions != null && !conditions.isEmpty();
    }
    
    public void addCondition(Condition condition) {
    	if (condition != null)
    		conditions.add(condition);
    }

    public TreeHierarchy getTreeHierarchy() {
    	return treeHierarchy;
    }
    
    public boolean isSetTreeHierarchy() {
    	return treeHierarchy != null;
    }
    
    public void setTreeHierarchy(TreeHierarchy treeHierarchy) {
    	this.treeHierarchy = treeHierarchy;
    }
    
    public String getTable() {
        return table;
    }

    public boolean isSetTable() {
        return table != null && !table.isEmpty();
    }
    
    public void setTable(String table) {
    	this.table = table;
    }

    public String getFromColumn() {
        return fromColumn;
    }

    public boolean isSetFromColumn() {
        return fromColumn != null && !fromColumn.isEmpty();
    }
    
    public void setFromColumn(String fromColumn) {
    	this.fromColumn = fromColumn;
    }

    public String getToColumn() {
        return toColumn;
    }

    public boolean isSetToColumn() {
        return toColumn != null && !toColumn.isEmpty();
    }
    
    public void setToColumn(String toColumn) {
    	this.toColumn = toColumn;
    }

	public TableRole getToRole() {
		return toRole;
	}
	
	public boolean isSetToRole() {
		return toRole != null;
	}

	public void setToRole(TableRole toRole) {
		this.toRole = toRole;
	}

	@Override
	protected void validate(SchemaMapping schemaMapping, Object parent, Object transitiveParent) throws SchemaMappingException {
		String toTable = null;
		
		if (parent instanceof AbstractTypeProperty<?>)
			toTable = ((AbstractTypeProperty<?>)parent).getType().getTable();
		else if (parent instanceof AbstractType<?>)
			toTable = ((AbstractType<?>)parent).getTable();
		else if (parent instanceof AbstractExtension<?>)
			toTable = ((AbstractExtension<?>)parent).getBase().getTable();
		else if (parent instanceof ComplexAttribute) {
			ComplexAttribute attribute = (ComplexAttribute)parent;
			if (attribute.refType != null)
				toTable = attribute.refType.getTable();
		}

		if (toTable != null && !table.equalsIgnoreCase(toTable) && !table.equals(MappingConstants.TARGET_TABLE_TOKEN))
			throw new SchemaMappingException("Expected target table '" + toTable + "' for join element but found '" + table + "'.");
		
		if (isSetTreeHierarchy()) {
			if (!(parent instanceof FeatureProperty) && !(parent instanceof ObjectProperty))
				throw new SchemaMappingException("A tree hierarchy can only be modelled for object and feature properties.");
			
			AbstractObjectType<?> type = null;
			if (transitiveParent instanceof AbstractObjectType<?>)
				 type = (AbstractObjectType<?>)transitiveParent;
			else if (parent instanceof InjectedProperty)
				type = ((InjectedProperty)parent).getBase();
			else
				throw new SchemaMappingException("Failed to determine the root target of the tree hierarchy.");
			
			if (!type.getTable().equals(table))			
				throw new SchemaMappingException("A tree hierarchy can only be modelled for self joins.");	
		}
	}

}
