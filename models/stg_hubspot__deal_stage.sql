{{ config(
    alias='stg_hubspot_deal_stage',
    enabled=fivetran_utils.enabled_vars(['hubspot_sales_enabled','hubspot_deal_enabled'])
) }}

with base as (

    select *
    from {{ var('deal_stage') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(var('deal_stage')),
                staging_columns=get_deal_stage_columns()
            )
        }}

    from base
),

final as (

    select
        date_entered,
        deal_id,
        source,
        source_id,
        value as deal_stage_name,
        _fivetran_active,
        _fivetran_end,
        _fivetran_start
    from fields
)

select *
from final
