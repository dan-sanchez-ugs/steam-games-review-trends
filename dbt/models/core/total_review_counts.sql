{{config(
    materialized = 'table'
)}}

select 
    'positive_reviews' as review_type, sum(positive_reviews) as review_count
from {{ref('stg_review_data')}}
union all
select 
    'negative_reviews' as review_type, sum(negative_reviews) as review_count
from {{ref('stg_review_data')}}
union all
select 
    'total_reviews' as review_type, sum(total_reviews) as review_count
from {{ref('stg_review_data')}}
