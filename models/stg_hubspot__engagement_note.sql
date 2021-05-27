{{ config(
    alias='stg_hubspot_engagement_note',
    enabled=fivetran_utils.enabled_vars(['hubspot_sales_enabled','hubspot_engagement_enabled','hubspot_engagement_note_enabled'])
) }}

with base as (

    select *
    from {{ var('engagement_note') }}

), macro as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(var('engagement_note')),
                staging_columns=get_engagement_note_columns()
            )
        }}
    from base

), fields as (

    select
        _fivetran_synced,
        body as note,
        engagement_id
    from macro

)

select *
from fields
