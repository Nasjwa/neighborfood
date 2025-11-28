module RatingsHelper
  # Render star icons for a rating (returns HTML safe string)
  #
  # rating - numeric value (Float, BigDecimal, Integer) or nil
  # options:
  #   :max        - max number of stars (default 5)
  #   :precision  - :nearest | :half | :floor  (default :nearest)
  #   :show_number - true/false (append numeric value) (default true)
  #   :css_class  - additional class for the star wrapper
  #
  def stars_for(rating, max: 5, precision: :nearest, show_number: true, css_class: nil)
    return content_tag(:span, "No reviews yet", class: "stars-wrapper #{css_class}") if rating.nil?

    r = rating.to_f.clamp(0.0, max.to_f)

    full = 0
    half = 0

    case precision
    when :floor
      full = r.floor
    when :half
      # round to nearest 0.5
      rounded = (r * 2).round / 2.0
      full = rounded.floor
      half = ((rounded - full) >= 0.5) ? 1 : 0
    else # :nearest
      full = r.round
    end

    full = full.to_i
    half = half.to_i
    empty = (max - full - half).to_i

    stars_html = +""
    full.times  { stars_html << full_star_svg }
    half.times  { stars_html << half_star_svg }
    empty.times { stars_html << empty_star_svg }

    result = content_tag(:span, stars_html.html_safe, class: "stars-wrapper #{css_class}")
    if show_number
      result << " ".html_safe
      result << content_tag(:small, number_with_precision(r, precision: 1), class: "stars-number")
    end

    result.html_safe
  end

  private

  def full_star_svg
    %(
      <svg class="star star--full" width="18" height="18" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
        <path fill="currentColor" d="M12 .587l3.668 7.431 8.2 1.192-5.934 5.789 1.402 8.168L12 18.896 4.664 23.167 6.066 14.999.132 9.21l8.2-1.192z"/>
      </svg>
    )
  end

  def half_star_svg
    %(
      <svg class="star star--half" width="18" height="18" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
        <defs>
          <linearGradient id="half-grad-#{object_id}" x1="0" x2="1">
            <stop offset="50%" stop-color="currentColor"/>
            <stop offset="50%" stop-color="transparent" stop-opacity="1"/>
          </linearGradient>
        </defs>
        <path fill="url(#half-grad-#{object_id})" d="M12 .587l3.668 7.431 8.2 1.192-5.934 5.789 1.402 8.168L12 18.896 4.664 23.167 6.066 14.999.132 9.21l8.2-1.192z"/>
        <path fill="none" stroke="currentColor" stroke-width="0.5" d="M12 .587l3.668 7.431 8.2 1.192-5.934 5.789 1.402 8.168L12 18.896 4.664 23.167 6.066 14.999.132 9.21l8.2-1.192z"/>
      </svg>
    )
  end

  def empty_star_svg
    %(
      <svg class="star star--empty" width="18" height="18" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
        <path fill="none" stroke="currentColor" stroke-width="1.2" d="M12 .587l3.668 7.431 8.2 1.192-5.934 5.789 1.402 8.168L12 18.896 4.664 23.167 6.066 14.999.132 9.21l8.2-1.192z"/>
      </svg>
    )
  end
end
