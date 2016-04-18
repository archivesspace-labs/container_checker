SELECT
         CASE
           WHEN i.accession_id IS NOT NULL then CONCAT( "(", a.id, ")", "  ", a.title, "  " )
         ELSE NULL
         END as accession,
         CASE
           WHEN i.resource_id IS NOT NULL then CONCAT( "(", r.id, ")", "  ", r.title, "  " )
           WHEN i.archival_object_id IS NOT NULL then CONCAT( "(", r2.id, ")", "  ", r2.title, "  " )
         ELSE NULL
         END as resource,
         CASE
          WHEN i.archival_object_id IS NOT NULL then CONCAT( "(", ao.id, ")", "  ", ao.title, "  " )
          ELSE NULL
          END as archival_object,
         i.id,
         tc.barcode AS barcode_1,
         CASE
             WHEN tc.type_id IS NOT NULL THEN t1.value
             ELSE NULL
         END AS type_1,
         tc.indicator AS indicator_1,
         CASE
             WHEN c.type_2_id IS NOT NULL THEN t2.value
             ELSE NULL
         END AS type_2,
         c.indicator_2,
         CASE
             WHEN c.type_3_id IS NOT NULL THEN t3.value
             ELSE NULL
         END AS type_3,
         c.indicator_3,
         CASE 
         	WHEN i.accession_id IS NOT NULL then CONCAT("/repositories/", a.repo_id, "/accessions/", a.id)
         	WHEN i.archival_object_id IS NOT NULL then CONCAT("/repositories/", ao.repo_id, "/archival_objects/", ao.id)
         	WHEN i.resource_id IS NOT NULL then CONCAT("/repositories/", r.repo_id, "/resources/", r.id)
         END AS uri,
         ( SELECT GROUP_CONCAT(l.id SEPARATOR '|' ) FROM Location l
         WHERE l.id IN ( SELECT location_id FROM top_container_housed_at_rlshp WHERE top_container_id = tc.id ) ) AS locations
     FROM instance AS i
     LEFT JOIN sub_container AS c ON ( c.instance_id = i.id )
     LEFT JOIN top_container_link_rlshp AS rlsph ON ( rlsph.sub_container_id = c.id )
     LEFT JOIN top_container AS tc ON ( rlsph.top_container_id = tc.id )
     LEFT JOIN accession AS a ON (  i.accession_id IS NOT NULL AND a.id = i.accession_id ) 
     LEFT JOIN archival_object AS ao ON ( i.archival_object_id IS NOT NULL AND ao.id = i.archival_object_id )
     LEFT JOIN resource AS r ON (  i.resource_id IS NOT NULL AND r.id = i.resource_id ) 
     LEFT JOIN resource AS r2 ON (  i.archival_object_id IS NOT NULL AND ( ao.id = i.archival_object_id AND r2.id = ao.root_record_id ) ) 
     LEFT JOIN enumeration_value as t1 ON (  tc.type_id IS NOT NULL AND tc.type_id = t1.id ) 
     LEFT JOIN enumeration_value as t2 ON (  c.type_2_id IS NOT NULL AND c.type_2_id = t2.id  )
     LEFT JOIN enumeration_value as t3 ON (  c.type_3_id IS NOT NULL AND c.type_3_id = t3.id )
	 ORDER BY (CASE WHEN a.id IS NULL then 1 ELSE 0 END), a.id, ( CASE WHEN r.id IS NULL then 1 ELSE 0 END), r.id, (CASE WHEN r2.id IS NULL then 1 ELSE 0 END), r2.id, ( CASE WHEN ao.id IS NULL then 1 ELSE 0 END ), ao.id, tc.type_id, tc.indicator, c.type_2_id, c.indicator_2, c.type_3_id, c.indicator_3
     INTO OUTFILE '/tmp/top_containers.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
ESCAPED BY '\\'
LINES TERMINATED BY '\n'; 
