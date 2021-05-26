{{ config(
    alias='stg_hubspot_engagement',
    enabled=fivetran_utils.enabled_vars(['hubspot_sales_enabled','hubspot_engagement_enabled'])
) }}

with base as (

    select *
    from {{ var('engagement') }}

), macro as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(var('engagement')),
                staging_columns=get_engagement_columns()
            )
        }}
    from base

), fields as (

    select
        _fivetran_synced,
        active as is_active,
        activity_type,
        created_at as created_timestamp,
        id as engagement_id,
        last_updated as last_updated_timestamp,
        owner_id,
        portal_id,
        occurred_timestamp,
        engagement_type
    from macro

)

select *
from fields
