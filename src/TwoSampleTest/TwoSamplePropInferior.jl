"""
$(TYPEDEF)

Two sample non-inferiority test for proportion

Constructors
------------
* `TwoSamplePropInferior(p1::Real, p2::Real, k::Real, delta::Real)`

Arguments
---------
* `p1`: Proportion of group 1

* `p2`: Proportion of group 2

* `k`: Ratio of the groups, k = n(group1) / n(group 2)

* `delta`: Non-inferiority Margin

Fields
------
$(FIELDS)
"""
type TwoSamplePropInferior <: TrialTest
    p1::Real
    p2::Real
    k::Real
    delta::Real

    # Validator
    function TwoSamplePropInferior(p1, p2, k, delta)

        if !((0 < p1 < 1) & (0 < p2 < 1))

            error("Proportion values must be in (0, 1)")

        end # end if

        if !(0 < k < Inf)

            error("Sampling ratio must be in (0, Inf)")

        end # end if

        if !(-1 < delta <= 0)

            error("The non-inferiority margin δ must be in (-1, 0]")

        end # end if

        new(p1, p2, k, delta)

    end # end function

end # function


# Two sample non-inferiority test for proportion
function hypotheses{T <: TwoSamplePropInferior}(test::T, n::Real, std::Void, alpha::Real, side::String)

    diff = test.p1 - test.p2 - delta
    se = sqrt(1 / n * test.p1 * (1 - test.p1) + 1 / (k * n) * test.p2 * (1 - test.p2))
    z = diff / se
    p = cdf(ZDIST, z - quantile(ZDIST, 1 - alpha)) + cdf(ZDIST, -z - quantile(ZDIST, 1 - alpha))
    return p

end # end function
