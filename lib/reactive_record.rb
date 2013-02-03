require "reactive_record/version"

require 'pg'
require 'active_support/inflector'

module ReactiveRecord
  def model_definition db, table_name
    res = []
    res << "class #{table_name.classify.pluralize} < ActiveRecord::Base"
    res << "  set_table_name '#{table_name}'"
    res << "  set_primary_key :#{primary_key db, table_name}"

    present_cols = non_nullable_columns(db, table_name).map { |c| ":#{c}" }
    unless present_cols.empty?
      res << "  validate #{present_cols.join ', '}, presence: true"
    end
    res << "end"

    res.join "\n"
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

  def primary_key db, table_name
    result = db.exec """
      SELECT column_name AS primary_key
      FROM pg_constraint, information_schema.columns
      WHERE table_name = $1
      AND contype = 'p'
      AND ordinal_position = any(conkey);
    """, [table_name]
    result.first["primary_key"]
  end

  def non_nullable_columns db, table_name
    result = db.exec """
      SELECT column_name
      FROM information_schema.columns
      WHERE table_name = $1
      AND Is_nullable = $2
    """, [table_name, 'NO']
    result.map { |r| r['column_name'] }
  end

  def constraint_to_validation constraint
  end
end
