/*View based column level access restriction based on the session usser*/


SELECT pii_data.customer_id, pii_data."domain",
        CASE
            WHEN pii_users.pii_permission IS NULL THEN 'NULL'::character varying
            ELSE pii_data.clear_name
        END AS clear_name,
        CASE
            WHEN pii_users.pii_permission IS NULL THEN 'NULL'::character varying
            ELSE pii_data.clear_email
        END AS clear_email
   FROM ( SELECT customers.customer_id, customers."domain",customers.clear_name, customers.clear_email, 'Y'::character varying AS pii_permission
           FROM customer_info.customers) pii_data
   LEFT JOIN ( SELECT cust_secure_users.login_name, 'Y'::character varying AS pii_permission
           FROM customer_info.cust_secure_users
          WHERE cust_secure_users.login_name::bpchar = (( SELECT "current_user"() AS "current_user"))) pii_users ON pii_data.pii_permission::text = pii_users.pii_permission::text;
