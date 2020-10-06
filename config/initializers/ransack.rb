Ransack.configure do |c|
  c.custom_arrows = {
    up_arrow: '<i class="fas fa-arrow-up"></i>',
    down_arrow: '<i class="fas fa-arrow-down"></i>',
    default_arrow: '<i class="fas fa-sort"></i>'
  }
end

Ransack.configure do |config|
  config.add_predicate 'date_equals',
    arel_predicate: 'eq',
    formatter: proc { |v| v.to_date },
    validator: proc { |v| v.present? },
    type: :string
end
