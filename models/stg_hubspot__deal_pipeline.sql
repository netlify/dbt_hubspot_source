{{ config(
    alias='stg_hubspot_deal_pipeline',
    enabled=fivetran_utils.enabled_vars(['hubspot_sales_enabled','hubspot_deal_enabled'])
) }}

with base as (

    select *
    from {{ var('deal_pipeline') }}
    where not coalesce(_fivetran_deleted, false)

), macro as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(var('deal_pipeline')),
                staging_columns=get_deal_pipeline_columns()
            )
        }}
    from base

), fields as (

    select
        _fivetran_deleted,
        _fivetran_synced,
        active as is_active,
        display_order,
        label as pipeline_label,
        pipeline_id as deal_pipeline_id
    from macro

)

select *
from fields
