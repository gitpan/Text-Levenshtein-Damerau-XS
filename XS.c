/*
 * This file was generated automatically by ExtUtils::ParseXS version 3.04 from the
 * contents of XS.xs. Do not edit this file, edit XS.xs instead.
 *
 *    ANY CHANGES MADE HERE WILL BE LOST!
 *
 */

#line 1 "XS.xs"
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
 
#define MIN(a,b) (((a)<(b))?(a):(b))
 

/* Our unsorted dictionary/hash tracker. */
/* Note we use character ints, not chars */

struct dictionary{
  int key;
  unsigned int value;
  struct dictionary* next;
};
typedef struct dictionary item;
 
static item* push(int key,unsigned int value,item* curr){
  item* head;
  Newx(head, sizeof(item), item);   
  head->key = key;
  head->value = value;
  head->next = curr;
  return head;
}

static item* dict_free(item* head){
  item* iterator = head;
  while(iterator){
	item* temp = iterator;
	iterator = iterator->next;
	Safefree(temp);
  }

  head = NULL;
}
 
static item* find(item* head,unsigned int key){
  item* iterator = head;
  while(iterator){
    if(iterator->key == key){
      return iterator;
    }
    iterator = iterator->next;
  }
 
  return NULL;
}

/* End of Dictionary Stuff */



 
/* All calculations/work are done here */

static int scores(int src[],int tgt[],unsigned int ax,unsigned int ay,unsigned int maxDistance){
  unsigned int i,j;
  unsigned int scores[ax+2][ay+2];
  item *head = NULL;
  int INF = ax + ay;
  scores[0][0] = INF; 
 
  /* setup scoring matrix */
  for(i=0;i<=ax;i++){
    scores[i+1][1] = i;
    scores[i+1][0] = INF;
 
    if(find(head,src[i]) == NULL){
      head = push(src[i],0,head);
    }
  }
  for(j=0;j<=ay;j++){
    scores[1][j+1] = j;
    scores[0][j+1] = INF;
 
    if(find(head,tgt[j]) == NULL){
      head = push(tgt[j],0,head);
    }
  }
 
 
  /* work loop */
  unsigned int db,i1,j1;
  for(i=1;i<=ax;i++){
    db = 0;
    for(j=1;j<=ay;j++){
      i1 = find(head,tgt[j-1])->value;
      j1 = db;
 
      if(src[i-1] == tgt[j-1]){
        scores[i+1][j+1] = scores[i][j];
        db = j;
      }else{
        scores[i+1][j+1] = MIN(scores[i][j], MIN(scores[i+1][j], scores[i][j+1])) + 1;
      }
	 
      scores[i+1][j+1] = MIN(scores[i+1][j+1], scores[i1][j1] + i - i1 - 1 + j - j1);
    }


    /* We will give up here if the */
    /* current score > maxDistance */
    if(maxDistance != 0 && maxDistance < scores[i+1][ay+1]) {
       dict_free(head); 
	return -1;
    }

    find(head,src[i-1])->value = i;
  }

  return scores[ax+1][ay+1];
}




/* For passing in Perl data types and converting to C */

static int cxs_edistance (AV* arraySource, AV* arrayTarget, SV* maxDistance) {
    unsigned int i,j;
    unsigned int lenSource = av_len(arraySource)+1;
    unsigned int lenTarget = av_len(arrayTarget)+1;
    int arrSource [ lenSource ];
    int arrTarget [ lenTarget ];
    unsigned int lenSource2 = 0;
    unsigned int lenTarget2 = 0;
 
    for (i=0; i < lenSource; i++) {
        SV** elem = av_fetch(arraySource, i, 0);
        int retval = (int)SvIV(*elem);
 
        if (elem != NULL) {
            arrSource[ i ] = retval;
             lenSource2++;
        }
    }
    for (j=0; j < lenTarget; j++) {
        SV** elem = av_fetch(arrayTarget, j, 0);
        int retval = (int)SvIV(*elem);

        if (elem != NULL) {
            arrTarget[ j ] = retval;
             lenTarget2++;
        }
    }

    return scores(arrSource,arrTarget,lenSource2,lenTarget2,(int)SvIV(maxDistance));
}


#line 162 "XS.c"
#ifndef PERL_UNUSED_VAR
#  define PERL_UNUSED_VAR(var) if (0) var = var
#endif

/* Starting from 5.15.2, XS(name) defines a static function (==internal)
 * and the XS_EXTERNAL macro is used for functions that must not be static
 * like the boot XSUB of a module. If perl didn't have an XS_EXTERNAL
 * macro defined, the best we can do is assume XS is the same.
 */
#ifndef XS_EXTERNAL
#  define XS_EXTERNAL(name) XS(name)
#endif
#ifndef PERL_ARGS_ASSERT_CROAK_XS_USAGE
#define PERL_ARGS_ASSERT_CROAK_XS_USAGE assert(cv); assert(params)

/* prototype to pass -Wmissing-prototypes */
STATIC void
S_croak_xs_usage(pTHX_ const CV *const cv, const char *const params);

STATIC void
S_croak_xs_usage(pTHX_ const CV *const cv, const char *const params)
{
    const GV *const gv = CvGV(cv);

    PERL_ARGS_ASSERT_CROAK_XS_USAGE;

    if (gv) {
        const char *const gvname = GvNAME(gv);
        const HV *const stash = GvSTASH(gv);
        const char *const hvname = stash ? HvNAME(stash) : NULL;

        if (hvname)
            Perl_croak(aTHX_ "Usage: %s::%s(%s)", hvname, gvname, params);
        else
            Perl_croak(aTHX_ "Usage: %s(%s)", gvname, params);
    } else {
        /* Pants. I don't think that it should be possible to get here. */
        Perl_croak(aTHX_ "Usage: CODE(0x%"UVxf")(%s)", PTR2UV(cv), params);
    }
}
#undef  PERL_ARGS_ASSERT_CROAK_XS_USAGE

#ifdef PERL_IMPLICIT_CONTEXT
#define croak_xs_usage(a,b)    S_croak_xs_usage(aTHX_ a,b)
#else
#define croak_xs_usage        S_croak_xs_usage
#endif

#endif

/* NOTE: the prototype of newXSproto() is different in versions of perls,
 * so we define a portable version of newXSproto()
 */
#ifdef newXS_flags
#define newXSproto_portable(name, c_impl, file, proto) newXS_flags(name, c_impl, file, proto, 0)
#else
#define newXSproto_portable(name, c_impl, file, proto) (PL_Sv=(SV*)newXS(name, c_impl, file), sv_setpv(PL_Sv, proto), (CV*)PL_Sv)
#endif /* !defined(newXS_flags) */

#line 222 "XS.c"

XS(XS_Text__Levenshtein__Damerau__XS_cxs_edistance); /* prototype to pass -Wmissing-prototypes */
XS(XS_Text__Levenshtein__Damerau__XS_cxs_edistance)
{
#ifdef dVAR
    dVAR; dXSARGS;
#else
    dXSARGS;
#endif
    if (items != 3)
       croak_xs_usage(cv,  "arraySource, arrayTarget, maxDistance");
    {
	AV *	arraySource;
	AV *	arrayTarget;
	SV *	maxDistance = ST(2)
;
	int	RETVAL;
	dXSTARG;

	if (SvROK(ST(0)) && SvTYPE(SvRV(ST(0)))==SVt_PVAV)
	    arraySource = (AV*)SvRV(ST(0));
	else
	    Perl_croak(aTHX_ "%s: %s is not an array reference",
			"Text::Levenshtein::Damerau::XS::cxs_edistance",
			"arraySource")
;

	if (SvROK(ST(1)) && SvTYPE(SvRV(ST(1)))==SVt_PVAV)
	    arrayTarget = (AV*)SvRV(ST(1));
	else
	    Perl_croak(aTHX_ "%s: %s is not an array reference",
			"Text::Levenshtein::Damerau::XS::cxs_edistance",
			"arrayTarget")
;

	RETVAL = cxs_edistance(arraySource, arrayTarget, maxDistance);
	XSprePUSH; PUSHi((IV)RETVAL);
    }
    XSRETURN(1);
}

#ifdef __cplusplus
extern "C"
#endif
XS_EXTERNAL(boot_Text__Levenshtein__Damerau__XS); /* prototype to pass -Wmissing-prototypes */
XS_EXTERNAL(boot_Text__Levenshtein__Damerau__XS)
{
#ifdef dVAR
    dVAR; dXSARGS;
#else
    dXSARGS;
#endif
#if (PERL_REVISION == 5 && PERL_VERSION < 9)
    char* file = __FILE__;
#else
    const char* file = __FILE__;
#endif

    PERL_UNUSED_VAR(cv); /* -W */
    PERL_UNUSED_VAR(items); /* -W */
#ifdef XS_APIVERSION_BOOTCHECK
    XS_APIVERSION_BOOTCHECK;
#endif
    XS_VERSION_BOOTCHECK;

        newXS("Text::Levenshtein::Damerau::XS::cxs_edistance", XS_Text__Levenshtein__Damerau__XS_cxs_edistance, file);
#if (PERL_REVISION == 5 && PERL_VERSION >= 9)
  if (PL_unitcheckav)
       call_list(PL_scopestack_ix, PL_unitcheckav);
#endif
    XSRETURN_YES;
}

