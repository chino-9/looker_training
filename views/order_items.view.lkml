view: order_items {
  sql_table_name: "PUBLIC"."ORDER_ITEMS"
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."CREATED_AT" ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."DELIVERED_AT" ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."INVENTORY_ITEM_ID" ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."RETURNED_AT" ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}."SALE_PRICE" ;;
  }

  dimension_group: shipped {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."SHIPPED_AT" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."USER_ID" ;;
  }

  # ディメンション演習2
  dimension: shipping_days {
    type: number
    sql: DATEDIFF(day, ${shipped_date}, ${delivered_date} ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # メジャー演習1
  measure: order_count {
    description: "A count of unique orders"
    type:  count_distinct
    sql: ${order_id} ;;
  }

  # メジャー演習2
  measure: total_sales {
    type: sum
    sql: ${sale_price} ;;
  }

  # メジャー演習3
  measure: average_sales {
    type: average
    sql: ${sale_price} ;;
  }

  # 応用フィールド演習1
  measure: total_sales_email_users {
    type: sum
    sql: ${sale_price} ;;
    filters: {
      field: users.is_email_source
      value: "yes"
    }
  }

  # 応用フィールド演習2
  measure: percentage_sales_email_source {
    type: number
    value_format_name: percent_2
    sql: 1.0 * ${total_sales_email_users}
         /NULLIF(${total_sales}, 0) ;;
  }

  # 応用フィールド演習3
  measure: average_spend_per_user {
    type: number
    value_format_name: usd
    sql: 1.0 * ${total_sales} / NULLIF(${users.count}, 0) ;;
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      users.first_name,
      users.id,
      users.last_name,
      inventory_items.id,
      inventory_items.product_name
    ]
  }
}
