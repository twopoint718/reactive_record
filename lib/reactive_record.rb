require_relative "./reactive_record/version"

require 'pg'
require 'active_support/inflector'

module ReactiveRecord
  def model_definition db, table_name
    res = []
    res << "class #{table_name.classify.pluralize} < ActiveRecord::Base"
    res << "  set_table_name '#{table_name}'"
    res << "  set_primary_key :#{primary_key db, table_name}"
    res << ''
    res += validate_definition non_nullable_columns(db, table_name), 'presence'
    res += validate_definition unique_columns(db, table_name), 'uniqueness'
    res << "end\n"

    res.join "\n"
  end

  def validate_definition cols, type
    res = []
    return res if cols.empty?
    symbols = cols.map { |c| ":#{c}" }
    ["  validate #{symbols.join ', '}, #{type}: true"]
  end

  def table_names db
    results = db.exec(
      "select table_name from information_schema.tables where table_schema = $1",
      ['public']
    )
    results.map { |r| r['table_name'] }
  end

  def constraints db
    result = db.exec """
      SELECT n.nspname || '.' || c.relname AS table_name,
             con.conname AS constraint_name,
             pg_get_constraintdef( con.oid, false) AS constraint_src
      FROM pg_constraint con
        JOIN pg_namespace n on (n.oid = con.connamespace)
        JOIN pg_class c on (c.oid = con.conrelid)
      WHERE con.conrelid != 0;
    """
    result
      .map{|c| [c['table_name'], c['constraint_name'], c['constraint_src']]}
      .sort
      .group_by{|item| item[0]} # table name
  end

  def cols_with_contype db, table_name, type
    db.exec """
      SELECT column_name, conname
      FROM pg_constraint, information_schema.columns
      WHERE table_name = $1
      AND contype = $2
      AND ordinal_position = any(conkey);
    """, [table_name, type]
  end

  def column_name
    lambda {|row| row['column_name']}
  end

  def primary_key db, table_name
    matching_primary_key = lambda {|row| row['conname'] == "#{table_name}_pkey"}
    cols_with_contype(db, table_name, 'p')
      .select(&matching_primary_key)
      .map(&column_name)
      .first
  end

  def unique_columns db, table_name
    matching_unique_constraint = lambda {|row| row['conname'] == "#{table_name}_#{row['column_name']}_key"}
    cols_with_contype(db, table_name, 'u')
      .select(&matching_unique_constraint)
      .map(&column_name)
  end

  def non_nullable_columns db, table_name
    result = db.exec """
      SELECT column_name
      FROM information_schema.columns
      WHERE table_name = $1
      AND is_nullable = $2
    """, [table_name, 'NO']
    result.map { |r| r['column_name'] }
  end

  def constraint_to_validation constraint
    # todo
  end
end
