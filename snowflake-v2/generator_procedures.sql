-- Create a procedure that generates a sequence of numbers from 1 to 10
-- Language: SQL

CREATE OR REPLACE FUNCTION generate_start_degrees(n integer)
  RETURNS TABLE (i integer, start_degrees float)
  LANGUAGE SQL
  AS
    $$
    SELECT row_number() over(order by 1) as i,
           (i - 1)::float * 360.0/n as start_degrees
      FROM TABLE(GENERATOR(ROWCOUNT => n))
    $$;


select * from table(generate_start_degrees(30));  

-- create a function generate_end_degrees
CREATE OR REPLACE FUNCTION generate_end_degrees(n integer)
  RETURNS TABLE (i integer, end_degrees float)
  LANGUAGE SQL
  AS
    $$
    SELECT row_number() over(order by 1) as i,
           i::float * 360.0/n as end_degrees
      FROM TABLE(GENERATOR(ROWCOUNT => n))
    $$;

-- Unit test
select * from table(generate_end_degrees(27));


SELECT row_number() over(order by 1) as id,
(id - 1) * 360/12 
  FROM TABLE(GENERATOR(ROWCOUNT => 12));