{{ config(
    alias='stg_hubspot_engagement_contact',
    enabled=fivetran_utils.enabled_vars(['hubspot_sales_enabled','hubspot_engagement_enabled','hubspot_engagement_contact_enabled'])
) }}

with base as (

    select *
    from {{ var('engagement_contact') }}

), macro as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(var('engagement_contact')),
                staging_columns=get_engagement_contact_columns()
            )
        }}
    from base

), fields as (

    select
        _fivetran_synced,
        contact_id,
        engagement_id
    from macro

)

select *
from fields
