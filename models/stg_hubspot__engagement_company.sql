{{ config(
    alias='stg_hubspot_engagement_company',
    enabled=fivetran_utils.enabled_vars(['hubspot_sales_enabled','hubspot_engagement_enabled','hubspot_engagement_company_enabled'])
) }}

with base as (

    select *
    from {{ var('engagement_company') }}

), macro as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(var('engagement_company')),
                staging_columns=get_engagement_company_columns()
            )
        }}
    from base

), fields as (

    select
        _fivetran_synced,
        company_id,
        engagement_id
    from macro

)

select *
from fields
