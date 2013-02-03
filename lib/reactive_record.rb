require "reactive_record/version"

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
    res << "end"

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

  def constraints db, table_name
  end

  def cols_with_contype db, table_name, type
    result = db.exec """
      SELECT column_name
      FROM pg_constraint, information_schema.columns
      WHERE table_name = $1
      AND contype = $2
      AND ordinal_position = any(conkey);
    """, [table_name, type]
    result.map { |c| c["column_name"] }
  end

  def primary_key db, table_name
    cols_with_contype(db, table_name, 'p').first
  end

  def unique_columns db, table_name
    cols_with_contype db, table_name, 'u'
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
  end
end
