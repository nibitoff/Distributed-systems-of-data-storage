\prompt 'Введите название схемы: ' given_schema
\set given_schema '\'' :given_schema'\''
select showinfo(:given_schema);
