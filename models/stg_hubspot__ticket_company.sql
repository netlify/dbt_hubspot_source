{{ config(
    alias='stg_hubspot_ticket_company',
    enabled=var('hubspot_service_enabled', False)
) }}

with base as (

    select *
    from {{ var('ticket_company') }}

), macro as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(var('ticket_company')),
                staging_columns=get_ticket_company_columns()
            )
        }}
    from base

), fields as (

    select
        _fivetran_synced,
        ticket_id,
        company_id

    from macro

)

select *
from fields
