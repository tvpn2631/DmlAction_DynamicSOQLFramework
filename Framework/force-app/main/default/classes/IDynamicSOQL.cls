/**
* @File Name : IDynamicSOQL.cls
* @Description : This interface class is a method signature for dynamic SOQL.
* @Author : Wilco
* @Last Modified By : Wilco
* @Last Modified On : November 22, 2024
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | November 22, 2024 |   | Initial Version
**/
public interface IDynamicSOQL {
    
    /**
	 * Method to set the object type to query.
	 *
	 * @param objectType A string parameter will hold sobject name.
	 */
    void setObjectType(String objectType); 
    
    /**
	 * Method to add a field to the SELECT clause.
	 *
	 * @param fieldName A string parameter will hold field api name.
	 */
    void addField(String fieldName);
    
    /**
	 * Method to add a WHERE condition.
	 *
	 * @param condition A string parameter will hold where clause condition.
	 */
    void addCondition(String condition);
    
    /**
	 * Method to add ORDER BY clause.
	 *
	 * @param field A string parameter will hold order by field api name.
     * @param order A string parameter will hold order by (asc, desc).
	 */
    void addOrderBy(String field, String order);

	/**
	 * Method to add ORDER BY clause.
	 *
	 * @param orderByClause A string parameter will hold order by field api name.
	 */
    void addOrderBy(String orderByClause);
    
    /**
	 * Method to execute the built query and return the results.
	 */
    List<SObject> executeQuery();

    /**
	 * Method to execute the built query and return the results.
	 */
    List<SObject> executeQuery(String queryString);
    
    /**
	 * Method to get the constructed SOQL query string.
	 */
    String getQuery();

	/**
	 * Method to clear utils variables.
	 */
    void clearUtilsVars();
}