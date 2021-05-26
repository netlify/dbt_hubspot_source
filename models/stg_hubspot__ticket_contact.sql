{{ config(
    alias='stg_hubspot_ticket_contact',
    enabled=var('hubspot_service_enabled', False)
) }}

with base as (

    select *
    from {{ var('ticket_contact') }}

), macro as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(var('ticket_contact')),
                staging_columns=get_ticket_contact_columns()
            )
        }}
    from base

), fields as (

    select
        _fivetran_synced,
        ticket_id,
        contact_id

    from macro

)

select *
from fields
