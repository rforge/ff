/*
   1-bit boolean vectors for R
   first bit is stored in lowest (rightmost) bit of forst word
   remember that rightshifting is dangerous because we use the sign position
   Copyright 2008 Jens Oehlschlägel
*/

#include <R.h>
#include <Rinternals.h>

int BITS;    // number of bits in one word
int LASTBIT; // last bit in word (=BITS-1)

/*
 & bitwise and
 | bitwise or
 ^ bitwise xor
 ~ bitwise not
*/


int *mask0, *mask1;

void bit_init(int   bits){
  BITS = bits;
  LASTBIT = bits - 1;
  mask0 = calloc(BITS, sizeof(int));
  mask1 = calloc(BITS, sizeof(int));
  int b = 1;
  int i;
  for (i=0; i<BITS; i++){
    mask1[i] = b;
    mask0[i] = ~b;
    //Rprintf("i=%d mask0[i]=%d mask1[i]=%d\n", i, mask0[i], mask1[i]);
    b = b << 1;
  }
}

void bit_done(){
  free(mask0);
  free(mask1);
}


SEXP R_bit_init(SEXP bits_){
  int bits = asInteger(bits_);
  bit_init(bits);
  return R_NilValue;
}
SEXP R_bit_done(){
  bit_done();
  return R_NilValue;
}


/*
  copy 'n' bits from 'bfrom' to 'bto' with offset 'oto'
  NOTE that remaining target bits AFTER the copied area are overwritten with zero
*/
void bit_shiftcopy(
  int *bsource /* bit source */
, int *btarget   /* bit target */
, int otarget    /* offset target */
, int n      /* number of bits to copy */
){
  register int upshift = otarget % BITS;    /* this is used for leftshifting bsource to meet btarget */
  int downshift = BITS - upshift;
  register int downshiftrest = downshift - 1;    /* this is used for downshiftresting bsource to meet btarget */

  int source_i  = 0;
  int target_i  = otarget;
  int source_i1 = n - 1;
  int target_i1 = otarget + n - 1;

  int source_j  = source_i  / BITS;
  int target_j  = target_i  / BITS;
  int source_j1 = source_i1 / BITS;
  int target_j1 = target_i1 / BITS;

  //int source_k  = source_i  % BITS;
  //int target_k  = target_i  % BITS;
  //int source_k1 = source_i1 % BITS;
  //int target_k1 = target_i1 % BITS;

  if (upshift){
    /* clean the positions of the new bits for the following OR */
    btarget[target_j] = (((btarget[target_j] << downshift) >> 1) & mask0[LASTBIT]) >> downshiftrest; /* special treatment of the leftmost bit in downshift to make sure the downshift is filled with zeros */
    /* now copy into part using OR */
    btarget[target_j] |= bsource[source_j] << upshift;
    target_j++;
    for (; source_j<source_j1; source_j++,target_j++){
      /* & mask0[LASTBIT] */
      btarget[target_j] = ( ((bsource[source_j] >> 1) & mask0[LASTBIT]) >> downshiftrest ) | ( bsource[source_j+1] << upshift ); /* special treatment of the leftmost bit in downshift to make sure the downshift is filled with zeros */
    }
  }else{
    for (; source_j<source_j1; source_j++,target_j++){
      btarget[target_j] = bsource[source_j];
    }
  }
  if (target_j==target_j1){
    if (upshift){
      /* clean the positions of the new bits for the following OR */
      btarget[target_j1] = ( ((btarget[target_j1] >> 1) & mask0[LASTBIT]) >> (upshift-1)) << upshift;
      /*  & mask0[LASTBIT] */
      btarget[target_j1] |= ( ((bsource[source_j1] >> 1) & mask0[LASTBIT]) >> downshiftrest ); /* special treatment of the leftmost bit in downshift to make sure the downshift is filled with zeros */
    }else{
      btarget[target_j1] = bsource[source_j1];
    }
  }
}



void bit_get(int *b, int *l, int from, int to){
  from--;
  to--;
  register int word;
  register int i=0;
  register int k=from%BITS;
  register int j=from/BITS;
  register int k1=to%BITS;
  register int j1=to/BITS;
  if (j<j1){
    word = b[j];
    for(; k<BITS; k++){
      l[i++] = word & mask1[k] ? 1 : 0;
    }
    for (j++; j<j1; j++){
      word = b[j];
      for(k=0 ;k<BITS ;k++){
        l[i++] = word & mask1[k] ? 1 : 0;
      }
    }
    k=0;
  }
  if (j==j1){
    word = b[j];
    for(; k<=k1 ;k++){
      l[i++] = word & mask1[k] ? 1 : 0;
    }
  }
}


void bit_set(int *b, int *l, int from, int to){
  from--;
  to--;
  register int word = 0;  /* this init only to keep compiler quiet */
  register int i=0;
  register int k=from%BITS;
  register int j=from/BITS;
  register int k1=to%BITS;
  register int j1=to/BITS;
  if (j<j1){
    word = b[j];
    for(; k<BITS; k++){
      if (l[i++])
        word |= mask1[k];
      else
        word &= mask0[k];
    }
    b[j] = word;
    for (j++; j<j1; j++){
      word = b[j];
      for(k=0 ;k<BITS; k++){
        if (l[i++])
          word |= mask1[k];
        else
          word &= mask0[k];
      }
      b[j] = word;
    }
    k = 0;
  }
  if (j==j1){
    word = b[j];
    for(; k<=k1 ;k++){
      if (l[i++])
        word |= mask1[k];
      else
        word &= mask0[k];
    }
    b[j] = word;
  }
}


void bit_which_positive(int *b, int *l, int from, int to, int offset){
  register int i=from + offset;
  from--;
  to--;
  register int word;
  register int h=0;
  register int k=from%BITS;
  register int j=from/BITS;
  register int k1=to%BITS;
  register int j1=to/BITS;
  if (j<j1){
    word = b[j];
    for(; k<BITS; k++){
      if (word & mask1[k])
        l[h++] = i;
      i++;
    }
    for (j++; j<j1; j++){
      word = b[j];
      for(k=0 ;k<BITS; k++){
        if (word & mask1[k])
          l[h++] = i;
        i++;
      }
    }
    k=0;
  }
  if (j==j1){
    word = b[j];
    for(; k<=k1 ;k++){
      if (word & mask1[k])
        l[h++] = i;
      i++;
    }
  }
}


void bit_which_negative(int *b, int *l, int from, int to){
  register int i= -to;
  from--;
  to--;
  register int word;
  register int h=0;
  register int k0=from%BITS;
  register int j0=from/BITS;
  register int k=to%BITS;
  register int j=to/BITS;
  if (j>j0){
    word = b[j];
    for(; k>=0; k--){
      if (!(word & mask1[k]))
        l[h++] = i;
      i++;
    }
    for (j--; j>j0; j--){
      word = b[j];
      for(k=LASTBIT ;k>=0 ;k--){
        if (!(word & mask1[k]))
          l[h++] = i;
        i++;
      }
    }
    k = LASTBIT;
  }
  if (j==j0){
    word = b[j];
    for( ;k>=k0 ;k--){
      if (!(word & mask1[k]))
        l[h++] = i;
      i++;
    }
  }
}


void bit_extract(int *b, int *i, int *l, int n){
  register int il, ib, j, k;
  for (il=0; il<n; il++){
    ib = i[il] - 1;
    j = ib/BITS;
    k = ib%BITS;
    l[il] = b[j] & mask1[k] ? 1 : 0;
    //Rprintf("il=%d ib=%d j=%d k=%d b[j]=%d mask1[k]=%d l[il]=%d\n", il, ib, j, k, b[j], mask1[k], l[il]);
  }
}

void bit_replace(int *b, int *i, int *l, int n){
  register int il, ib, j, k;
  for (il=0; il<n; il++){
    ib = i[il] - 1;
    j = ib/BITS;
    k = ib%BITS;
    //Rprintf("il=%d ib=%d j=%d k=%d b[j]=%d l[il]=%d mask1[k]=%d mask0[k]=%d\n", il, ib, j, k, b[j], l[il], mask1[k], mask0[k]);
    if (l[il])
      b[j] |= mask1[k];
    else
      b[j] &= mask0[k];
  }
}


void bit_not(int *b, int n){
  register int i;
  for (i=0; i<n; i++){
    b[i] = ~b[i];
  }
}


void bit_and(int *b1, int *b2, int *ret, int n){
  register int i;
  for (i=0; i<n; i++){
    ret[i] = b1[i] & b2[i];
  }
}

void bit_or(int *b1, int *b2, int *ret, int n){
  register int i;
  for (i=0; i<n; i++){
    ret[i] = b1[i] | b2[i];
  }
}

void bit_xor(int *b1, int *b2, int *ret, int n){
  register int i;
  for (i=0; i<n; i++){
    ret[i] = b1[i] ^ b2[i];
  }
}

void bit_equal(int *b1, int *b2, int *ret, int n){
  register int i;
  for (i=0; i<n; i++){
    ret[i] = ~(b1[i] ^ b2[i]);
  }
}


int bit_sum(int *b, int from, int to){
  from--;
  to--;
  register int word;
  register int s=0;
  register int k=from%BITS;
  register int j=from/BITS;
  register int k1=to%BITS;
  register int j1=to/BITS;
  if (j<j1){
    word = b[j];
    for(; k<BITS; k++){
      if (word & mask1[k])
        s++;
    }
    for (j++; j<j1; j++){
      word = b[j];
      for(k=0; k<BITS; k++){
        if (word & mask1[k])
          s++;
      }
    }
    k=0;
  }
  if (j==j1){
    word = b[j];
    for(; k<=k1; k++){
      if (word & mask1[k])
        s++;
    }
  }
  return s;
}


int bit_all(int *b, int from, int to){
  from--;
  to--;
  register int word;
  register int k=from%BITS;
  register int j=from/BITS;
  register int k1=to%BITS;
  register int j1=to/BITS;
  if (j<j1){
    word = b[j];
    for(; k<BITS; k--){
      if (!(word & mask1[k]))
        return 0;
    }
    for (j++; j<j1; j++){
      if(~(b[j]))
        return 0;
    }
    k=0;
  }
  if (j==j1){
    word = b[j];
    for(; k<=k1; k++){
      if (!(word & mask1[k]))
        return 0;
    }
  }
  return 1;
}



int bit_any(int *b, int from, int to){
  from--;
  to--;
  register int word;
  register int k=from%BITS;
  register int j=from/BITS;
  register int k1=to%BITS;
  register int j1=to/BITS;
  if (j<j1){
    word = b[j];
    for(; k<BITS; k++){
      if (word & mask1[k])
        return 1;
    }
    for (j++; j<j1; j++){
      if(b[j])
        return 1;
    }
    k=0;
  }
  if (j==j1){
    word = b[j];
    for(; k<=k1; k++){
      if(b[j])
        return 1;
    }
  }
  return 0;
}



int bit_min(int *b, int from, int to){
  from--;
  to--;
  register int word;
  register int k=from%BITS;
  register int j=from/BITS;
  register int k1=to%BITS;
  register int j1=to/BITS;
  if (j<j1){
    word = b[j];
    if(word){
      for(; k<BITS; k++){
        if (word & mask1[k]){
          return j*BITS + k + 1;
        }
      }
    }
    for (j++; j<j1; j++){
      word = b[j];
      if (word)
        for(k=0; k<BITS ;k++){
          if (word & mask1[k]){
            return j*BITS + k + 1;
          }
        }
    }
    k=0;
  }
  if (j==j1){
    word = b[j];
    if (word)
      for(; k<=k1; k++){
        if (word & mask1[k]){
          return j*BITS+k+1;
        }
      }
  }

  return NA_INTEGER;
}



int bit_max(int *b, int from, int to){
  from--;
  to--;
  register int word;
  register int k0=from%BITS;
  register int j0=from/BITS;
  register int k=to%BITS;
  register int j=to/BITS;
  if (j>j0){
    word = b[j];
    if (word){
      for(; k>=0; k--){
        if (word & mask1[k])
          return j*BITS+k+1;
      }
    }
    for (j--; j>j0; j--){
      word = b[j];
      if (word){
        for(k=LASTBIT; k>=0; k--){
          if (word & mask1[k])
            return j*BITS+k+1;
        }
      }
    }
    k=LASTBIT;
  }
  if (j==j0){
    word = b[j];
    if (word){
      for(; k>=k0; k--){
        if (word & mask1[k])
          return j*BITS+k+1;
      }
    }
  }
  return NA_INTEGER;
}


/* R interface functions -------------------- */

SEXP R_bit_shiftcopy(
  SEXP bsource_  /* bit source */
, SEXP btarget_    /* bit target: assumed FALSE in the target positions and above */
, SEXP otarget_    /* offset target */
, SEXP n_      /* number of bits to copy */
){
  int *bsource = INTEGER(bsource_);
  int *btarget = INTEGER(btarget_);
  int otarget = asInteger(otarget_);
  int n = asInteger(n_);
  bit_shiftcopy(bsource, btarget, otarget, n);
  return(btarget_);
}


SEXP R_bit_get(SEXP b_, SEXP l_, SEXP range_){
  int *b = INTEGER(b_);
  int *l = LOGICAL(l_);
  int *range = INTEGER(range_);
  bit_get(b, l, range[0], range[1]);
  return(l_);
}
SEXP R_bit_get_integer(SEXP b_, SEXP l_, SEXP range_){
  int *b = INTEGER(b_);
  int *l = INTEGER(l_);
  int *range = INTEGER(range_);
  bit_get(b, l, range[0], range[1]);
  return(l_);
}



SEXP R_bit_set(SEXP b_, SEXP l_, SEXP range_){
  int *b = INTEGER(b_);
  int *l = LOGICAL(l_);
  int *range = INTEGER(range_);
  bit_set(b, l, range[0], range[1]);
  return(b_);
}
SEXP R_bit_set_integer(SEXP b_, SEXP l_, SEXP range_){
  int *b = INTEGER(b_);
  int *l = INTEGER(l_);
  int *range = INTEGER(range_);
  bit_set(b, l, range[0], range[1]);
  return(b_);
}



SEXP R_bit_which(SEXP b_, SEXP s_, SEXP range_, SEXP negative_){
  int *b = INTEGER(b_);
  int *range = INTEGER(range_);
  int s = asInteger(s_);
  SEXP ret_;
  int *ret;
  if (asLogical(negative_)){
    // negative return
    PROTECT( ret_ = allocVector(INTSXP,s) );
    ret = INTEGER(ret_);
    bit_which_negative(b, ret, range[0], range[1]);
  }else{
    // positive return
    PROTECT( ret_ = allocVector(INTSXP,s) );
    ret = INTEGER(ret_);
    bit_which_positive(b, ret, range[0], range[1], 0);
  }
  UNPROTECT(1);
  return(ret_);
}



#define HANDLE_TRUE \
  d = i - li; \
  li = i; \
  if (d==ld){ \
    ln++; \
  }else{ \
    val[c] = ld; \
    len[c] = ln; \
    s+=ln; \
    c++; \
    if (c==n2){ \
      Free(val); \
      Free(len); \
      last = NA_INTEGER; j=j1 + 1; break; \
    } \
    ld = d; \
    ln = 1; \
  }

/* last=0 means aborting rle */

SEXP R_bit_as_hi(SEXP b_, SEXP range_, SEXP offset_)
{
  int *b = INTEGER(b_);
  int *range = INTEGER(range_);
  int offset = asInteger(offset_);
  SEXP ret_, first_, dat_, last_, len_, retnames_;
  int protectcount = 0;

  register int word;
  register int k=(range[0]-1)%BITS;
  register int j=(range[0]-1)/BITS;
  int k1=(range[1]-1)%BITS;
  int j1=(range[1]-1)/BITS;
  int first = NA_INTEGER;
  int last = -1;  /* setting this to NA_INTEGER means: abort rle */

  int  c = 0;               /* rle position */
  register int  i = NA_INTEGER;       /* position     */
  register int li = NA_INTEGER;       /* last position */
  register int  d = NA_INTEGER;       /* difference */
  register int ld = NA_INTEGER;       /* last difference */
  register int ln = 0;                /* counter of last difference */
  int s = 1; /* sum of TRUE */

  /* begin determine first and first increment d (stored in last_diff ld) */
  if (j<j1){
    word = b[j];
    for(; k<BITS; k++){
      //Rprintf(" pre1 j=%d k=%d i=%d\n", j,k, j*BITS+k);
      if (word & mask1[k]){
        if (first==NA_INTEGER)
          first = j*BITS + k;
        else{
          li = j*BITS + k;
          ld = li - first;
          ln = 1;
          break;
        }
      }
    }
    if (!ln){
      for (j++; j<j1; j++){
        word = b[j];
        for(k=0; k<BITS; k++){
          //Rprintf("main1 j=%d k=%d i=%d\n", j,k, j*BITS+k);
          if (word & mask1[k]){
            if (first==NA_INTEGER)
              first = j*BITS + k;
            else{
              li = j*BITS + k;
              ld = li - first;
              ln = 1;
              j = j1 + 1; break;;
            }
          }
        }
      }
    }
    k=0;
  }
  if (!ln && j==j1){
    word = b[j];
    for(; k<=k1; k++){
      //Rprintf("post1 j=%d k=%d i=%d\n", j,k, j*BITS+k);
      if (word & mask1[k]){
        if (first==NA_INTEGER)
          first = j*BITS + k;
        else{
          li = j*BITS + k;
          ld = li - first;
          ln = 1;
          break;
        }
      }
    }
  }
  /* end determine first and first increment d */


  if (first!=NA_INTEGER){  /* we have found at least one TRUE position */
    int n = range[1] - first;

    //Rprintf("CHECK: first=%d last=%d range[0]=%d range[1]=%d n=%d ln=%d\n", first, last, range[0], range[1], n, ln);

    if (ln && n>=3){
      /* see function intrle in package ff:
         max RAM requirement 2x, but rle only if at least 2/3 savings,
         using 2 instead of 3 would need 50% more time,
         have max RAM requirement 2.5x for savings of any size
         NOTE that n is a fuzzy worst case estimate of the number of TRUEs
         i.e. in some cases we miss the rle abort and use rle although simple positions would cost less RAM
       */
      int *val, *len;
      int n2 = n / 3;
      val = Calloc(n2, int);
      len = Calloc(n2, int);

      i=first+ld;
      k=(i+1)%BITS;
      j=(i+1)/BITS;

      //Rprintf("first=%d li=%d\n", first, li);


      /* begin determine increments */
      if (j<j1){
        word = b[j];
        for(; k<BITS; k++){
          i++;
          //Rprintf(" pre2 j=%d k=%d j*BITS+k=%d i=%d\n", j, k, j*BITS+k, i);
          if (word & mask1[k]){
            HANDLE_TRUE
          }
        }
        if (last!=NA_INTEGER){ /* not aborted rle */
          for (j++; j<j1; j++){
            word = b[j];
            for(k=0; k<BITS ;k++){
              i++;
              //Rprintf("main2 j=%d k=%d j*BITS+k=%d i=%d\n", j, k, j*BITS+k, i);
              if (word & mask1[k]){
                HANDLE_TRUE
              }
            }
          }
        }
        k = 0;
      }
      if (last!=NA_INTEGER && j==j1){ /* not aborted rle */
        word = b[j];
        for(; k<=k1; k++){
          i++;
          //Rprintf("post2 j=%d k=%d j*BITS+k=%d i=%d\n", j, k, j*BITS+k, i);
          if (word & mask1[k]){
            HANDLE_TRUE
          }
        }
      }
      if (last!=NA_INTEGER){ /* not aborted rle */
        int *values, *lengths;
        SEXP lengths_, values_, datnames_, class_;
        s += ln;
        val[c] = ld;
        len[c] = ln;
        c++;
        first++;
        last = range[1] - (i-li);
        /* end determine increments */
        PROTECT( values_ = allocVector(INTSXP, c) );
        values = INTEGER(values_);
        for (i=0;i<c;i++)
          values[i] = val[i];
        Free(val);
        PROTECT( lengths_ = allocVector(INTSXP, c) );
        lengths = INTEGER(lengths_);
        for (i=0;i<c;i++)
          lengths[i] = len[i];
        Free(len);

        PROTECT( dat_ = allocVector(VECSXP, 2) );
        PROTECT( datnames_ = allocVector(STRSXP, 2));
        PROTECT( class_ = allocVector(STRSXP, 1));

        SET_STRING_ELT(datnames_, 0, mkChar("lengths"));
        SET_STRING_ELT(datnames_, 1, mkChar("values"));
        SET_STRING_ELT(class_, 0, mkChar("rle"));
        SET_VECTOR_ELT(dat_, 0, lengths_);
        SET_VECTOR_ELT(dat_, 1, values_);
        setAttrib(dat_, R_NamesSymbol, datnames_);
        classgets(dat_, class_);

        protectcount += 5;
      }

    }else{
      last = NA_INTEGER; /* abort rle */
    }

    /* if rle aborted, do the simple positions */

    if (last==NA_INTEGER){
      int *dat;

      first++;
      s = bit_sum(b, first, range[1]);
      PROTECT( dat_ = allocVector(INTSXP, s) );
      dat = INTEGER(dat_);
      //Rprintf("1: offset=%d first=%d last=%d\n", offset, first, last);
      bit_which_positive(b, dat, first, range[1], offset);
      last = dat[s-1] - offset;
      //Rprintf("2: offset=%d first=%d last=%d\n", offset, first, last);

      protectcount++;
    }

  }else{
    /* all FALSE */
    last = NA_INTEGER;
    s = 0;
    PROTECT( dat_ = allocVector(INTSXP,0) );
    protectcount++;
  }

  PROTECT( first_ = allocVector(INTSXP, 1) );
  PROTECT( last_ = allocVector(INTSXP, 1) );
  PROTECT( len_ = allocVector(INTSXP, 1) );
  //Rprintf("3: offset=%d first=%d last=%d\n", offset, first, last);
  INTEGER(first_)[0] = offset + first;
  INTEGER(last_)[0] = offset + last;
  INTEGER(len_)[0] = s;
  PROTECT( ret_ = allocVector(VECSXP, 4) );

  PROTECT( retnames_ = allocVector(STRSXP, 4));
  SET_STRING_ELT(retnames_, 0, mkChar("first"));
  SET_STRING_ELT(retnames_, 1, mkChar("dat"));
  SET_STRING_ELT(retnames_, 2, mkChar("last"));
  SET_STRING_ELT(retnames_, 3, mkChar("len"));
  SET_VECTOR_ELT(ret_, 0, first_);
  SET_VECTOR_ELT(ret_, 1, dat_);
  SET_VECTOR_ELT(ret_, 2, last_);
  SET_VECTOR_ELT(ret_, 3, len_);
  setAttrib(ret_, R_NamesSymbol, retnames_);

  protectcount += 5;

  UNPROTECT(protectcount);
  return ret_;
}


#undef HANDLE_TRUE



SEXP R_bit_extract(SEXP b_, SEXP i_, SEXP l_){
  int *b = INTEGER(b_);
  int *i = INTEGER(i_);
  int *l = LOGICAL(l_);
  int n = LENGTH(i_);
  bit_extract(b, i, l, n);
  return(l_);
}

SEXP R_bit_replace(SEXP b_, SEXP i_, SEXP l_, SEXP negative_, SEXP range_){
  int *b = INTEGER(b_);
  int *i = INTEGER(i_);
  int *l = LOGICAL(l_);
  int n = LENGTH(i_);
  bit_replace(b, i, l, n);
  return(b_);
}



SEXP R_bit_not(SEXP b_){
  int *b = INTEGER(b_);
  int n = LENGTH(b_);
  bit_not(b, n);
  return(b_);
}

SEXP R_bit_and(SEXP b1_, SEXP b2_, SEXP ret_){
  int *b1 = INTEGER(b1_);
  int *b2 = INTEGER(b2_);
  int *ret = INTEGER(ret_);
  int n = LENGTH(b1_);
  bit_and(b1, b2, ret, n);
  return(ret_);
}

SEXP R_bit_or(SEXP b1_, SEXP b2_, SEXP ret_){
  int *b1 = INTEGER(b1_);
  int *b2 = INTEGER(b2_);
  int *ret = INTEGER(ret_);
  int n = LENGTH(b1_);
  bit_or(b1, b2, ret, n);
  return(ret_);
}

SEXP R_bit_xor(SEXP b1_, SEXP b2_, SEXP ret_){
  int *b1 = INTEGER(b1_);
  int *b2 = INTEGER(b2_);
  int *ret = INTEGER(ret_);
  int n = LENGTH(b1_);
  bit_xor(b1, b2, ret, n);
  return(ret_);
}

SEXP R_bit_equal(SEXP b1_, SEXP b2_, SEXP ret_){
  int *b1 = INTEGER(b1_);
  int *b2 = INTEGER(b2_);
  int *ret = INTEGER(ret_);
  int n = LENGTH(b1_);
  bit_equal(b1, b2, ret, n);
  return(ret_);
}


SEXP R_bit_sum(SEXP b_, SEXP range_){
  int *b = INTEGER(b_);
  int *range = INTEGER(range_);
  SEXP ret_;
  PROTECT( ret_ = allocVector(INTSXP,1) );
  INTEGER(ret_)[0] = bit_sum(b, range[0],  range[1]);
  UNPROTECT(1);
  return(ret_);
}

SEXP R_bit_all(SEXP b_, SEXP range_){
  int *b = INTEGER(b_);
  int *range = INTEGER(range_);
  SEXP ret_;
  PROTECT( ret_ = allocVector(LGLSXP,1) );
  LOGICAL(ret_)[0] = bit_all(b, range[0],  range[1]);
  UNPROTECT(1);
  return(ret_);
}


SEXP R_bit_any(SEXP b_, SEXP range_){
  int *b = INTEGER(b_);
  int *range = INTEGER(range_);
  SEXP ret_;
  PROTECT( ret_ = allocVector(LGLSXP,1) );
  LOGICAL(ret_)[0] = bit_any(b, range[0],  range[1]);
  UNPROTECT(1);
  return(ret_);
}

SEXP R_bit_min(SEXP b_, SEXP range_){
  int *b = INTEGER(b_);
  int *range = INTEGER(range_);
  SEXP ret_;
  PROTECT( ret_ = allocVector(INTSXP,1) );
  INTEGER(ret_)[0] = bit_min(b, range[0],  range[1]);
  UNPROTECT(1);
  return(ret_);
}

SEXP R_bit_max(SEXP b_, SEXP range_){
  int *b = INTEGER(b_);
  int *range = INTEGER(range_);
  SEXP ret_;
  PROTECT( ret_ = allocVector(INTSXP,1) );
  INTEGER(ret_)[0] = bit_max(b, range[0],  range[1]);
  UNPROTECT(1);
  return(ret_);
}


// performance tests without bit

void filter_getset(int *l1, int *l2, int n){
  int i;
  for (i=0; i<n; i++){
    if (l1[i])
      l2[i] = 1;
    else
      l2[i] = 0;
  }
}


SEXP R_filter_getset(SEXP l1_, SEXP l2_){
  int *l1 = LOGICAL(l1_);
  int *l2 = LOGICAL(l2_);
  int n = LENGTH(l1_);
  filter_getset(l1, l2, n);
  return(l2_);
}

