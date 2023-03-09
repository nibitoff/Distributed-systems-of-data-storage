create or replace function showinfo(given_schema text) returns void
as $$
DECLARE
    countTables integer;
    countIndexes integer;
    countColumns integer;
    row record;
begin
select count(*) from information_schema.tables where table_schema = given_schema into countTables;
select count(*) from information_schema.columns where table_schema = given_schema into countColumns;
select count(*) from pg_indexes where schemaname = given_schema into countIndexes;

raise info 'Количество таблиц в схеме % - %', given_schema, countTables;
    raise info 'Количество столбцов в схеме % - %',given_schema, countColumns;
    raise info 'Количество индексов в схеме % - %',given_schema, countIndexes;

    raise info  'Таблицы схемы %', given_schema;
    raise info 'Имя                         Столбцов           Строк';
    raise info '--------------------------------------------------------------------------';
FOR row in select information_schema.columns.table_name AS "Имя", count(information_schema.columns.column_name) as "Столбцов", pg_stat_user_tables.n_live_tup as "Строк"
           from information_schema.columns
                    inner join pg_stat_user_tables on information_schema.columns.table_name = pg_stat_user_tables.relname
           where information_schema.columns.table_schema = given_schema
           group by information_schema.columns.table_name, pg_stat_user_tables.n_live_tup
               LOOP
        RAISE INFO '% % %', rpad(row."Имя", 30, ' '), rpad(row."Столбцов"::text, 15, ' '), rpad(row."Строк"::text, 15, ' ');
END LOOP;
end;
$$
LANGUAGE 'plpgsql';