::
::::  /hoon/talk/sur
  !:
|%
::
::TODO  wrappers around knot for story name, nickname,
::TODO  use different words for different kinds of burdens
::
::>  ||
::>  ||  %query-models
::>  ||
::>    models relating to queries, their results and updates.
::+|
::
++  query                                               ::>  query paths
  $%  {$reader $~}                                      ::<  shared ui state
      {$burden who/ship}                                ::<  duties to share
      {$report $~}                                      ::<  duty reports
      {$circle nom/knot ran/range}                      ::<  story query
      ::TODO  separate stream for just msgs? what about just configs? presences?
      ::      yes!
  ==                                                    ::
++  range                                               ::>  inclusive msg range
  %-  unit                                              ::<  ~ means everything
  $:  hed/place                                         ::<  start of range
      tal/(unit place)                                  ::<  opt end of range
  ==                                                    ::
++  place                                               ::>  range indicators
  $%  {$da @da}                                         ::<  date
      {$ud @ud}                                         ::<  message number
  ==                                                    ::
++  prize                                               ::>  query result
  $%  {$reader prize-reader}                            ::<  /reader
      {$friend cis/(set circle)}                        ::<  /friend
      {$burden sos/(map knot burden)}                   ::<  /burden
      ::TODO  do we ever use remote things from remote circles?
      {$circle burden}                                  ::<  /circle
  ==                                                    ::
++  prize-reader                                        ::
  $:  gys/(jug char (set circle))                       ::<  glyph bindings
      nis/(map ship cord)                               ::<  nicknames
  ==                                                    ::
++  rumor                                               ::<  query result change
  $%  {$reader dif/rumor-reader}                        ::<  /reader
      {$friend add/? cir/circle}                        ::<  /friend
      {$burden nom/knot dif/diff-story}                 ::<  /burden
      {$circle dif/diff-story}                          ::<  /circle
  ==                                                    ::
++  rumor-reader                                        ::<  changed ui state
  $%  {$glyph diff-glyph}                               ::<  un/bound glyph
      {$nick diff-nick}                                 ::<  changed nickname
  ==                                                    ::
++  burden                                              ::<  full story state
  $:  gaz/(list telegram)                               ::<  all messages
      cos/lobby                                         ::<  loc & rem configs
      pes/crowd                                         ::<  loc & rem presences
  ==                                                    ::
::TODO  deltas into app
++  delta                                               ::
  $%  ::  messaging state                               ::
      {$out cir/circle out/(list thought)}              ::<  msgs into outbox
      ::  shared ui state                               ::
      {$glyph diff-glyph}                               ::<  un/bound glyph
      {$nick diff-nick}                                 ::<  changed nickname
      ::  story state                                   ::
      {$story nom/knot dif/delta-story}                 ::<  change to story
      ::  side-effects                                  ::
      {$init $~}                                        ::<  initialize
      {$observe who/ship}                               ::<  watch burden bearer
      {$present hos/ship nos/(set knot) dif/diff-status}::<  send %present cmd
      {$quit ost/bone}                                  ::<  force unsubscribe
  ==                                                    ::
++  diff-glyph  {bin/? gyf/char pas/(set circle)}       ::<  un/bound glyph
++  diff-nick   {who/ship nic/cord}                     ::<  changed nickname
++  delta-story                                         ::<  story delta
  $?  diff-story                                        ::<  both in & outward
  $%  {$inherited ihr/?}                                ::<  inherited flag
      {$follow sub/? cos/(map circle range)}            ::<  un/subscribe
  ==  ==                                                ::
++  diff-story                                          ::<  story rumor
  $%  {$new cof/config}                                 ::<  new story
      {$bear bur/burden}                                ::<  new inherited story
      {$grams gaz/(list telegram)}                      ::<  new/changed msgs
      {$config cir/circle dif/diff-config}              ::<  new/changed config
      {$status cir/circle who/ship dif/diff-status}     ::<  new/changed status
      {$remove $~}                                      ::<  removed story
  ==                                                    ::
++  diff-config                                         ::>  config change
  ::TODO  maybe just full? think.
  $%  {$full cof/config}                                ::<  set w/o side-effects
      {$source add/? cir/circle}                        ::<  add/rem sources
      {$caption cap/cord}                               ::<  changed description
      {$filter fit/filter}                              ::<  changed filter
      {$secure sec/security}                            ::<  changed security
      {$permit add/? sis/(set ship)}                    ::<  add/rem to b/w-list
      {$remove $~}                                      ::<  removed config
  ==                                                    ::
++  diff-status                                         ::>  status change
  $%  {$full sat/status}                                ::<  fully changed status
      {$presence pec/presence}                          ::<  changed presence
      {$human dif/diff-human}                           ::<  changed name
      {$remove $~}                                      ::<  removed config
  ==                                                    ::
++  diff-human                                          ::>  name change
  $%  {$full man/human}                                 ::<  fully changed name
      {$true tru/(unit (trel cord (unit cord) cord))}   ::<  changed true name
      {$handle han/(unit cord)}                         ::<  changed handle
  ==                                                    ::
::
::>  ||
::>  ||  %reader-communication
::>  ||
::>    broker interfaces for readers.
::+|
::
++  action                                              ::>  user action
  $%  ::  circle configuration                          ::
      {$create nom/knot des/cord sec/security}          ::<  create circle
      {$delete nom/knot why/(unit cord)}                ::<  delete + announce
      {$depict nom/knot des/cord}                       ::<  change description
      {$filter nom/knot fit/filter}                     ::<  change message rules
      {$permit nom/knot inv/? sis/(set ship)}           ::<  invite/banish
      {$source nom/knot sub/? src/(map circle range)}   ::<  un/sub to/from src
      ::  messaging                                     ::
      {$convey tos/(list thought)}                      ::<  post exact
      {$phrase aud/(set circle) ses/(list speech)}      ::<  post easy
      ::  personal metadata                             ::
      {$notify cis/(set circle) pes/presence}           ::<  our presence update
      {$naming cis/(set circle) man/human}              ::<  our name update
      ::  changing shared ui                            ::
      {$glyph gyf/char pas/(set circle) bin/?}          ::<  un/bind a glyph
      {$nick who/ship nic/knot}                         ::<  new identity
  ==                                                    ::
::
::>  ||
::>  ||  %broker-communication
::>  ||
::>    structures for communicating between brokers.
::+|
::
++  command                                             ::>  effect on story
  $%  {$publish tos/(list thought)}                     ::<  deliver
      {$present nos/(set knot) dif/diff-status}         ::<  status update
      {$bearing $~}                                     ::<  prompt to listen
  ==                                                    ::
::
::>  ||
::>  ||  %circles
::>  ||
::>    messaging targets and their metadata.
::+|
::
++  circle     {hos/ship nom/knot}                      ::<  native target
++  passport                                            ::>  foreign target
  $%  {$twitter p/cord}                                 ::<  twitter handle
  ==                                                    ::
::  circle configurations.                              ::
++  lobby      {loc/config rem/(map circle config)}     ::<  our & srcs configs
++  config                                              ::>  circle config
  $:  src/(set circle)                                  ::<  active sources
      ::TODO  ^ include range? just remove!
      cap/cord                                          ::<  description
      fit/filter                                        ::<  message rules
      con/control                                       ::<  restrictions
  ==                                                    ::
++  filter                                              ::>  content filters
  $:  cas/?                                             ::<  dis/allow capitals
      utf/?                                             ::<  dis/allow non-ascii
      ::TODO  maybe message length
  ==                                                    ::
++  control    {sec/security ses/(set ship)}            ::<  access control
++  security                                            ::>  security mode
  $?  $black                                            ::<  channel, blacklist
      $white                                            ::<  village, whitelist
      $green                                            ::<  journal, author list
      $brown                                            ::<  mailbox, our r, bl w
  ==                                                    ::
::  participant metadata.                               ::
::TODO  think about naming more
++  crowd      {loc/group rem/(map circle group)}       ::<  our & srcs presences
++  group      (map ship status)                        ::<  presence map
++  status     {pec/presence man/human}                 ::<  participant
++  presence                                            ::>  status type
  $?  $gone                                             ::<  absent
      $idle                                             ::<  idle
      $hear                                             ::<  present
      $talk                                             ::<  typing
  ==                                                    ::
++  human                                               ::>  human identifier
  $:  han/(unit cord)                                   ::<  handle
      tru/(unit (trel cord (unit cord) cord))           ::<  true name
  ==                                                    ::
::
::>  ||
::>  ||  %message-data
::>  ||
::>    structures for containing main message data.
::+|
::
++  telegram   {aut/ship thought}                       ::<  whose message
++  thought                                             ::>  inner message
  $:  uid/serial                                        ::<  unique identifier
      aud/audience                                      ::<  destinations
      wen/@da                                           ::<  timestamp
      sep/speech                                        ::<  content
  ==                                                    ::
++  speech                                              ::>  content body
  $%  {$lin pat/? msg/cord}                             ::<  no/@ text line
      {$url url/purf}                                   ::<  parsed url
      {$exp exp/cord res/(list tank)}                   ::<  hoon line
      {$fat tac/attache sep/speech}                     ::<  attachment
      {$inv inv/? cir/circle}                           ::<  inv/ban for circle
      {$app app/term msg/cord}                          ::<  app message
  ==                                                    ::
++  attache                                             ::>  attachment
  $%  {$name nom/cord tac/attache}                      ::<  named attachment
      {$text (list cord)}                               ::<  text lines
      {$tank (list tank)}                               ::<  tank list
  ==                                                    ::
::
::>  ||
::>  ||  %message-metadata
::>  ||
::     structures for containing message metadata.
::+|
::
++  serial     @uvH                                     ::<  unique identifier
++  audience   (set circle)                             ::<  destinations
--
