$(function () {
  function sizeHTML() {
    var html = `<label for="post_product_size">サイズ</label>
                    <span class="require__form">必須</span>
                    <div class="select__box">
                      <select class="select__box__format" name="post[product_size]" id="post_product_size">
                        <option>---</option>
                        <option value="xxs_or_less">XXS以下</option>
                        <option value="xs">XS(SS)</option>
                        <option value="small">S</option>
                        <option value="middle">M</option>
                        <option value="large">L</option>
                        <option value="xl">XL(LL)</option>
                        <option value="xxl">2XL(3L)</option>
                        <option value="xxxl">3XL(4L)</option>
                        <option value="xxxxl_or_more">4XL(5L)以上</option>
                        <option value="free">FREE SIZE</option>
                      </select>
                      <div class="drop-down-icon">
                        <i class="fas fa-chevron-down"></i>
                      </div>
                    </div>`
    return html
  }
  
  $(document).on("change", "#post_third_category_id", function () {
    var input = $('#post_first_category_id').val();
    if (input > 2 ) {
      $('#size-content').empty();
    } else {
      if ($('#post_product_size').length == 0) {
        var html = sizeHTML();
        $('#size-content').append(html);
      }
    }
  });
});

