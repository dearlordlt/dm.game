<?php

class Category {

    function __construct() { //Constructor
    }
    
    function getAllCategories() {
        $category_rs = mysql_query("SELECT * FROM object_categories;");
        while ($category = mysql_fetch_object($category_rs))
            $categories[] = $category;
        return $categories;
    }

    function saveCategory($category, $userId) {
        if ($category->id == 0)
            mysql_query("INSERT INTO object_categories (label, object_type_id, last_modified, last_modified_by) VALUES ('$category->label', $category->object_type_id, NOW(), $userId);");
        else
            mysql_query("UPDATE categories SET label='$category->label', last_modified=NOW(), last_modified_by=$userId WHERE id=$category->id;");
        return mysql_error();
    }

}

?>