import $ from 'jquery';
import 'select2';

const initSelect2 = () => {
  $('.select2').select2({
    dropdownParent: $("#myModal"),
    minimumInputLength: 2
  });
};

export { initSelect2 };
