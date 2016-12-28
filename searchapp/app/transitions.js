export default function(){
  this.transition(
    this.hasClass('nested-form'),

    // this makes our rule apply when the liquid-if transitions to the
    // true state.
    this.toValue(true),
    this.use('crossFade', {duration: 20}),

    // which means we can also apply a reverse rule for transitions to
    // the false state.
    this.reverse('toLeft', {duration: 20})
  );
};