#include "types.h"
#include "user.h"
#include "date.h"

int stdout = 1;
int stderr = 2;

int
main(int argc, char *argv[])
{
  struct rtcdate r;

  if (date(&r)) {
    printf(stderr, "Erro na chamada de sistema\n");
    exit();
  }

  // Imprima a data aqui
  printf(stdout, "Data: %d/%d/%d Hora: %d:%d:%d\n", 
        r.day, r.month, r.year, 
        r.hour, r.minute, r.second);

  exit();
}