connection: "snowlooker"

# include all the views
include: "/views/**/*.view"

# キャッシュ設定
datagroup: default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

datagroup: order_items {
  sql_trigger: select max(created_at) from order_items;;
  max_cache_age: "4 hours"
}

persist_with: default_datagroup

explore: distribution_centers {}

explore: etl_jobs {}

explore: events {
  join: users {
    type: left_outer
    sql_on: ${events.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: inventory_items {
  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: order_items {
  # datagroup設定
  persist_with: order_items
  # Exploreフィルタ追加
#   sql_always_where: ${returned_date} IS NULL and ${status} = 'complete';;
  sql_always_where: ${status} = 'Complete';;
#   sql_always_having: ${total_sales} > 200 and ${count} > 5000;;
#   sql_always_having: ${count} > 5000;;

  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: products {
  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

# Explore演習
explore: users {
  # Exploreフィルタ演習
  always_filter: {
    filters: {
      field: order_items.created_date
      value: "last 30 days"
    }
  }

  conditionally_filter: {
    filters: {
      field: order_items.created_date
      value: "last 90 days"
    }
    unless: [id, state]
  }

  join: order_items {
    type: left_outer
    sql_on: ${users.id} = ${order_items.user_id} ;;
    relationship: one_to_many
  }
}
