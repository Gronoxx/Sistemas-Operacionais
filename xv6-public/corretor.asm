
_corretor:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
                                        r->minute,
                                        r->second);
}


int main(int argc, char *argv[]) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
  struct rtcdate r;
  int call_ok = 1;

  printf(stdout, "[Caso 0] Testando o date\n");
  call_ok = get_date(&r);
   f:	8d 5d e0             	lea    -0x20(%ebp),%ebx
int main(int argc, char *argv[]) {
  12:	83 ec 28             	sub    $0x28,%esp
  printf(stdout, "[Caso 0] Testando o date\n");
  15:	68 8e 13 00 00       	push   $0x138e
  1a:	ff 35 28 1a 00 00    	push   0x1a28
  20:	e8 6b 0c 00 00       	call   c90 <printf>
  call_ok = get_date(&r);
  25:	89 1c 24             	mov    %ebx,(%esp)
  28:	e8 23 08 00 00       	call   850 <get_date>
  if (call_ok == FALSE) {
  2d:	83 c4 10             	add    $0x10,%esp
  30:	85 c0                	test   %eax,%eax
  32:	75 17                	jne    4b <main+0x4b>
    printf(stdout, "[Caso 0 - ERROR] Falhou!\n");
  34:	50                   	push   %eax
  35:	50                   	push   %eax
  36:	68 a8 13 00 00       	push   $0x13a8
  3b:	ff 35 28 1a 00 00    	push   0x1a28
  41:	e8 4a 0c 00 00       	call   c90 <printf>
    exit();
  46:	e8 c8 0a 00 00       	call   b13 <exit>
  }
  print_date(&r);
  4b:	83 ec 0c             	sub    $0xc,%esp
  4e:	53                   	push   %ebx
  4f:	e8 3c 08 00 00       	call   890 <print_date>
  printf(stdout, "[Caso 0] OK\n");
  54:	58                   	pop    %eax
  55:	5a                   	pop    %edx
  56:	68 c2 13 00 00       	push   $0x13c2
  5b:	ff 35 28 1a 00 00    	push   0x1a28
  61:	e8 2a 0c 00 00       	call   c90 <printf>

  get_date(&r);
  66:	89 1c 24             	mov    %ebx,(%esp)
  69:	e8 e2 07 00 00       	call   850 <get_date>
  print_date(&r);
  6e:	89 1c 24             	mov    %ebx,(%esp)
  71:	e8 1a 08 00 00       	call   890 <print_date>
  printf(stdout, "[Caso 1] Testando o fork\n");
  76:	59                   	pop    %ecx
  77:	58                   	pop    %eax
  78:	68 cf 13 00 00       	push   $0x13cf
  7d:	ff 35 28 1a 00 00    	push   0x1a28
  83:	e8 08 0c 00 00       	call   c90 <printf>
  call_ok = caso1fork();
  88:	e8 a3 02 00 00       	call   330 <caso1fork>
  if (call_ok == FALSE) {
  8d:	83 c4 10             	add    $0x10,%esp
  90:	85 c0                	test   %eax,%eax
  92:	75 17                	jne    ab <main+0xab>
    printf(stdout, "[Caso 1 - ERROR] Falhou!\n");
  94:	51                   	push   %ecx
  95:	51                   	push   %ecx
  96:	68 e9 13 00 00       	push   $0x13e9
  9b:	ff 35 28 1a 00 00    	push   0x1a28
  a1:	e8 ea 0b 00 00       	call   c90 <printf>
    exit();
  a6:	e8 68 0a 00 00       	call   b13 <exit>
  }
  printf(stdout, "[Caso 1] OK\n");
  ab:	50                   	push   %eax
  ac:	50                   	push   %eax
  ad:	68 03 14 00 00       	push   $0x1403
  b2:	ff 35 28 1a 00 00    	push   0x1a28
  b8:	e8 d3 0b 00 00       	call   c90 <printf>

  get_date(&r);
  bd:	89 1c 24             	mov    %ebx,(%esp)
  c0:	e8 8b 07 00 00       	call   850 <get_date>
  print_date(&r);
  c5:	89 1c 24             	mov    %ebx,(%esp)
  c8:	e8 c3 07 00 00       	call   890 <print_date>
  printf(stdout, "[Caso 2] Testando o forkcow\n");
  cd:	58                   	pop    %eax
  ce:	5a                   	pop    %edx
  cf:	68 10 14 00 00       	push   $0x1410
  d4:	ff 35 28 1a 00 00    	push   0x1a28
  da:	e8 b1 0b 00 00       	call   c90 <printf>
  call_ok = caso2forkcow();
  df:	e8 cc 02 00 00       	call   3b0 <caso2forkcow>
  if (call_ok == FALSE) {
  e4:	83 c4 10             	add    $0x10,%esp
  e7:	85 c0                	test   %eax,%eax
  e9:	74 57                	je     142 <main+0x142>
    printf(stdout, "[Caso 2 - ERROR] Falhou!\n");
    exit();
  }
  printf(stdout, "[Caso 2] OK\n");
  eb:	50                   	push   %eax
  ec:	50                   	push   %eax
  ed:	68 47 14 00 00       	push   $0x1447
  f2:	ff 35 28 1a 00 00    	push   0x1a28
  f8:	e8 93 0b 00 00       	call   c90 <printf>

  get_date(&r);
  fd:	89 1c 24             	mov    %ebx,(%esp)
 100:	e8 4b 07 00 00       	call   850 <get_date>
  print_date(&r);
 105:	89 1c 24             	mov    %ebx,(%esp)
 108:	e8 83 07 00 00       	call   890 <print_date>
  printf(stdout, "[Caso 3] Testando se o número de páginas é igual\n");
 10d:	58                   	pop    %eax
 10e:	5a                   	pop    %edx
 10f:	68 48 12 00 00       	push   $0x1248
 114:	ff 35 28 1a 00 00    	push   0x1a28
 11a:	e8 71 0b 00 00       	call   c90 <printf>
  call_ok = caso3numpgs();
 11f:	e8 0c 03 00 00       	call   430 <caso3numpgs>
  if (call_ok == FALSE) {
 124:	83 c4 10             	add    $0x10,%esp
 127:	85 c0                	test   %eax,%eax
 129:	75 2e                	jne    159 <main+0x159>
    printf(stdout, "[Caso 3 - ERROR] Falhou!\n");
 12b:	51                   	push   %ecx
 12c:	51                   	push   %ecx
 12d:	68 54 14 00 00       	push   $0x1454
 132:	ff 35 28 1a 00 00    	push   0x1a28
 138:	e8 53 0b 00 00       	call   c90 <printf>
    exit();
 13d:	e8 d1 09 00 00       	call   b13 <exit>
    printf(stdout, "[Caso 2 - ERROR] Falhou!\n");
 142:	51                   	push   %ecx
 143:	51                   	push   %ecx
 144:	68 2d 14 00 00       	push   $0x142d
 149:	ff 35 28 1a 00 00    	push   0x1a28
 14f:	e8 3c 0b 00 00       	call   c90 <printf>
    exit();
 154:	e8 ba 09 00 00       	call   b13 <exit>
  }
  printf(stdout, "[Caso 3] OK\n");
 159:	50                   	push   %eax
 15a:	50                   	push   %eax
 15b:	68 6e 14 00 00       	push   $0x146e
 160:	ff 35 28 1a 00 00    	push   0x1a28
 166:	e8 25 0b 00 00       	call   c90 <printf>

  get_date(&r);
 16b:	89 1c 24             	mov    %ebx,(%esp)
 16e:	e8 dd 06 00 00       	call   850 <get_date>
  print_date(&r);
 173:	89 1c 24             	mov    %ebx,(%esp)
 176:	e8 15 07 00 00       	call   890 <print_date>
  printf(stdout, "[Caso 4] Testando se o endereço de uma constante é =\n");
 17b:	58                   	pop    %eax
 17c:	5a                   	pop    %edx
 17d:	68 80 12 00 00       	push   $0x1280
 182:	ff 35 28 1a 00 00    	push   0x1a28
 188:	e8 03 0b 00 00       	call   c90 <printf>
  call_ok = caso4mesmoaddr();
 18d:	e8 8e 03 00 00       	call   520 <caso4mesmoaddr>
  if (call_ok == FALSE) {
 192:	83 c4 10             	add    $0x10,%esp
 195:	85 c0                	test   %eax,%eax
 197:	74 57                	je     1f0 <main+0x1f0>
    printf(stdout, "[Caso 4 - ERROR] Falhou!\n");
    exit();
  }
  printf(stdout, "[Caso 4] OK\n");
 199:	50                   	push   %eax
 19a:	50                   	push   %eax
 19b:	68 95 14 00 00       	push   $0x1495
 1a0:	ff 35 28 1a 00 00    	push   0x1a28
 1a6:	e8 e5 0a 00 00       	call   c90 <printf>

  get_date(&r);
 1ab:	89 1c 24             	mov    %ebx,(%esp)
 1ae:	e8 9d 06 00 00       	call   850 <get_date>
  print_date(&r);
 1b3:	89 1c 24             	mov    %ebx,(%esp)
 1b6:	e8 d5 06 00 00       	call   890 <print_date>
  printf(stdout, "[Caso 5] Testando se o endereço de uma global é =\n");
 1bb:	58                   	pop    %eax
 1bc:	5a                   	pop    %edx
 1bd:	68 b8 12 00 00       	push   $0x12b8
 1c2:	ff 35 28 1a 00 00    	push   0x1a28
 1c8:	e8 c3 0a 00 00       	call   c90 <printf>
  call_ok = caso5mesmoaddr();
 1cd:	e8 5e 04 00 00       	call   630 <caso5mesmoaddr>
  if (call_ok == FALSE) {
 1d2:	83 c4 10             	add    $0x10,%esp
 1d5:	85 c0                	test   %eax,%eax
 1d7:	75 2e                	jne    207 <main+0x207>
    printf(stdout, "[Caso 5 - ERROR] Falhou!\n");
 1d9:	51                   	push   %ecx
 1da:	51                   	push   %ecx
 1db:	68 a2 14 00 00       	push   $0x14a2
 1e0:	ff 35 28 1a 00 00    	push   0x1a28
 1e6:	e8 a5 0a 00 00       	call   c90 <printf>
    exit();
 1eb:	e8 23 09 00 00       	call   b13 <exit>
    printf(stdout, "[Caso 4 - ERROR] Falhou!\n");
 1f0:	51                   	push   %ecx
 1f1:	51                   	push   %ecx
 1f2:	68 7b 14 00 00       	push   $0x147b
 1f7:	ff 35 28 1a 00 00    	push   0x1a28
 1fd:	e8 8e 0a 00 00       	call   c90 <printf>
    exit();
 202:	e8 0c 09 00 00       	call   b13 <exit>
  }
  printf(stdout, "[Caso 5] OK\n");
 207:	50                   	push   %eax
 208:	50                   	push   %eax
 209:	68 bc 14 00 00       	push   $0x14bc
 20e:	ff 35 28 1a 00 00    	push   0x1a28
 214:	e8 77 0a 00 00       	call   c90 <printf>

  get_date(&r);
 219:	89 1c 24             	mov    %ebx,(%esp)
 21c:	e8 2f 06 00 00       	call   850 <get_date>
  print_date(&r);
 221:	89 1c 24             	mov    %ebx,(%esp)
 224:	e8 67 06 00 00       	call   890 <print_date>
  printf(stdout, "[Caso 6] Testando o COW\n");
 229:	58                   	pop    %eax
 22a:	5a                   	pop    %edx
 22b:	68 c9 14 00 00       	push   $0x14c9
 230:	ff 35 28 1a 00 00    	push   0x1a28
 236:	e8 55 0a 00 00       	call   c90 <printf>
  call_ok = caso6cow();
 23b:	e8 00 05 00 00       	call   740 <caso6cow>
  if (call_ok == FALSE) {
 240:	83 c4 10             	add    $0x10,%esp
 243:	85 c0                	test   %eax,%eax
 245:	75 17                	jne    25e <main+0x25e>
    printf(stdout, "[Caso 6 - ERROR] Falhou!\n");
 247:	50                   	push   %eax
 248:	50                   	push   %eax
 249:	68 e2 14 00 00       	push   $0x14e2
 24e:	ff 35 28 1a 00 00    	push   0x1a28
 254:	e8 37 0a 00 00       	call   c90 <printf>
    exit();
 259:	e8 b5 08 00 00       	call   b13 <exit>
  }
  printf(stdout, "[Caso 6] OK\n");
 25e:	50                   	push   %eax
 25f:	50                   	push   %eax
 260:	68 fc 14 00 00       	push   $0x14fc
 265:	ff 35 28 1a 00 00    	push   0x1a28
 26b:	e8 20 0a 00 00       	call   c90 <printf>
  printf(stdout, "\n");
 270:	5a                   	pop    %edx
 271:	59                   	pop    %ecx
 272:	68 62 15 00 00       	push   $0x1562
 277:	ff 35 28 1a 00 00    	push   0x1a28
 27d:	e8 0e 0a 00 00       	call   c90 <printf>
  printf(stdout, "         (__)        \n");
 282:	5b                   	pop    %ebx
 283:	58                   	pop    %eax
 284:	68 09 15 00 00       	push   $0x1509
 289:	ff 35 28 1a 00 00    	push   0x1a28
 28f:	e8 fc 09 00 00       	call   c90 <printf>
  printf(stdout, "         (oo)        \n");
 294:	58                   	pop    %eax
 295:	5a                   	pop    %edx
 296:	68 20 15 00 00       	push   $0x1520
 29b:	ff 35 28 1a 00 00    	push   0x1a28
 2a1:	e8 ea 09 00 00       	call   c90 <printf>
  printf(stdout, "   /------\\/        \n");
 2a6:	59                   	pop    %ecx
 2a7:	5b                   	pop    %ebx
 2a8:	68 37 15 00 00       	push   $0x1537
 2ad:	ff 35 28 1a 00 00    	push   0x1a28
 2b3:	e8 d8 09 00 00       	call   c90 <printf>
  printf(stdout, "  / |    ||          \n");
 2b8:	58                   	pop    %eax
 2b9:	5a                   	pop    %edx
 2ba:	68 4d 15 00 00       	push   $0x154d
 2bf:	ff 35 28 1a 00 00    	push   0x1a28
 2c5:	e8 c6 09 00 00       	call   c90 <printf>
  printf(stdout, " *  /\\---/\\        \n");
 2ca:	59                   	pop    %ecx
 2cb:	5b                   	pop    %ebx
 2cc:	68 64 15 00 00       	push   $0x1564
 2d1:	ff 35 28 1a 00 00    	push   0x1a28
 2d7:	e8 b4 09 00 00       	call   c90 <printf>
  printf(stdout, "    ~~   ~~          \n");
 2dc:	58                   	pop    %eax
 2dd:	5a                   	pop    %edx
 2de:	68 79 15 00 00       	push   $0x1579
 2e3:	ff 35 28 1a 00 00    	push   0x1a28
 2e9:	e8 a2 09 00 00       	call   c90 <printf>
  printf(stdout, "....\"Congratulations! You have mooed!\"...\n");
 2ee:	59                   	pop    %ecx
 2ef:	5b                   	pop    %ebx
 2f0:	68 f0 12 00 00       	push   $0x12f0
 2f5:	ff 35 28 1a 00 00    	push   0x1a28
 2fb:	e8 90 09 00 00       	call   c90 <printf>
  printf(stdout, "\n");
 300:	58                   	pop    %eax
 301:	5a                   	pop    %edx
 302:	68 62 15 00 00       	push   $0x1562
 307:	ff 35 28 1a 00 00    	push   0x1a28
 30d:	e8 7e 09 00 00       	call   c90 <printf>
  printf(stdout, "[0xDCC605 - COW] ALL OK!!!\n");
 312:	59                   	pop    %ecx
 313:	5b                   	pop    %ebx
 314:	68 90 15 00 00       	push   $0x1590
 319:	ff 35 28 1a 00 00    	push   0x1a28
 31f:	e8 6c 09 00 00       	call   c90 <printf>
  exit();
 324:	e8 ea 07 00 00       	call   b13 <exit>
 329:	66 90                	xchg   %ax,%ax
 32b:	66 90                	xchg   %ax,%ax
 32d:	66 90                	xchg   %ax,%ax
 32f:	90                   	nop

00000330 <caso1fork>:
int caso1fork(void) {
 330:	55                   	push   %ebp
 331:	89 e5                	mov    %esp,%ebp
 333:	53                   	push   %ebx
  for(n=0; n<N; n++){
 334:	31 db                	xor    %ebx,%ebx
int caso1fork(void) {
 336:	83 ec 08             	sub    $0x8,%esp
  printf(stdout, "[--Caso 1.1] Testando %d chamadas fork\n", N);
 339:	6a 0a                	push   $0xa
 33b:	68 b8 0f 00 00       	push   $0xfb8
 340:	ff 35 28 1a 00 00    	push   0x1a28
 346:	e8 45 09 00 00       	call   c90 <printf>
 34b:	83 c4 10             	add    $0x10,%esp
 34e:	66 90                	xchg   %ax,%ax
    pid = fork();
 350:	e8 b6 07 00 00       	call   b0b <fork>
    if(pid < 0) {
 355:	85 c0                	test   %eax,%eax
 357:	78 27                	js     380 <caso1fork+0x50>
    if(pid == 0)
 359:	74 4c                	je     3a7 <caso1fork+0x77>
      if (wait() < 0) return FALSE;
 35b:	e8 bb 07 00 00       	call   b1b <wait>
 360:	85 c0                	test   %eax,%eax
 362:	78 3c                	js     3a0 <caso1fork+0x70>
  for(n=0; n<N; n++){
 364:	83 c3 01             	add    $0x1,%ebx
 367:	83 fb 0a             	cmp    $0xa,%ebx
 36a:	75 e4                	jne    350 <caso1fork+0x20>
}
 36c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return TRUE;
 36f:	b8 01 00 00 00       	mov    $0x1,%eax
}
 374:	c9                   	leave  
 375:	c3                   	ret    
 376:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 37d:	8d 76 00             	lea    0x0(%esi),%esi
      printf(stdout, "[--Caso 1.1 - ERROR] Fork %d falhou!\n", n);
 380:	83 ec 04             	sub    $0x4,%esp
 383:	53                   	push   %ebx
 384:	68 e0 0f 00 00       	push   $0xfe0
 389:	ff 35 28 1a 00 00    	push   0x1a28
 38f:	e8 fc 08 00 00       	call   c90 <printf>
}
 394:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return FALSE;
 397:	83 c4 10             	add    $0x10,%esp
 39a:	31 c0                	xor    %eax,%eax
}
 39c:	c9                   	leave  
 39d:	c3                   	ret    
 39e:	66 90                	xchg   %ax,%ax
 3a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      if (wait() < 0) return FALSE;
 3a3:	31 c0                	xor    %eax,%eax
}
 3a5:	c9                   	leave  
 3a6:	c3                   	ret    
      exit();   // fecha filho
 3a7:	e8 67 07 00 00       	call   b13 <exit>
 3ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000003b0 <caso2forkcow>:
int caso2forkcow(void) {
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	53                   	push   %ebx
  for(n=0; n<N; n++){
 3b4:	31 db                	xor    %ebx,%ebx
int caso2forkcow(void) {
 3b6:	83 ec 08             	sub    $0x8,%esp
  printf(stdout, "[--Caso 2.1] Testando %d chamadas forkcow\n", N);
 3b9:	6a 0a                	push   $0xa
 3bb:	68 08 10 00 00       	push   $0x1008
 3c0:	ff 35 28 1a 00 00    	push   0x1a28
 3c6:	e8 c5 08 00 00       	call   c90 <printf>
 3cb:	83 c4 10             	add    $0x10,%esp
 3ce:	66 90                	xchg   %ax,%ax
    pid = forkcow();
 3d0:	e8 f6 07 00 00       	call   bcb <forkcow>
    if(pid < 0) {
 3d5:	85 c0                	test   %eax,%eax
 3d7:	78 27                	js     400 <caso2forkcow+0x50>
    if(pid == 0)
 3d9:	74 4c                	je     427 <caso2forkcow+0x77>
      if (wait() < 0) return FALSE;
 3db:	e8 3b 07 00 00       	call   b1b <wait>
 3e0:	85 c0                	test   %eax,%eax
 3e2:	78 3c                	js     420 <caso2forkcow+0x70>
  for(n=0; n<N; n++){
 3e4:	83 c3 01             	add    $0x1,%ebx
 3e7:	83 fb 0a             	cmp    $0xa,%ebx
 3ea:	75 e4                	jne    3d0 <caso2forkcow+0x20>
}
 3ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return TRUE;
 3ef:	b8 01 00 00 00       	mov    $0x1,%eax
}
 3f4:	c9                   	leave  
 3f5:	c3                   	ret    
 3f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3fd:	8d 76 00             	lea    0x0(%esi),%esi
      printf(stdout, "[--Caso 2.1 - ERROR] Fork %d falhou!\n", n);
 400:	83 ec 04             	sub    $0x4,%esp
 403:	53                   	push   %ebx
 404:	68 34 10 00 00       	push   $0x1034
 409:	ff 35 28 1a 00 00    	push   0x1a28
 40f:	e8 7c 08 00 00       	call   c90 <printf>
}
 414:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return FALSE;
 417:	83 c4 10             	add    $0x10,%esp
 41a:	31 c0                	xor    %eax,%eax
}
 41c:	c9                   	leave  
 41d:	c3                   	ret    
 41e:	66 90                	xchg   %ax,%ax
 420:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      if (wait() < 0) return FALSE;
 423:	31 c0                	xor    %eax,%eax
}
 425:	c9                   	leave  
 426:	c3                   	ret    
      exit();   // fecha filho
 427:	e8 e7 06 00 00       	call   b13 <exit>
 42c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000430 <caso3numpgs>:
int caso3numpgs(void) {
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	56                   	push   %esi
 434:	53                   	push   %ebx
  pipe(fd);
 435:	8d 45 dc             	lea    -0x24(%ebp),%eax
int caso3numpgs(void) {
 438:	83 ec 2c             	sub    $0x2c,%esp
  pipe(fd);
 43b:	50                   	push   %eax
 43c:	e8 e2 06 00 00       	call   b23 <pipe>
  int np = num_pages();
 441:	e8 7d 07 00 00       	call   bc3 <num_pages>
 446:	89 c3                	mov    %eax,%ebx
  int pid = forkcow();
 448:	e8 7e 07 00 00       	call   bcb <forkcow>
  if (pid == 0) { // child manda número de páginas de da exit
 44d:	83 c4 10             	add    $0x10,%esp
 450:	85 c0                	test   %eax,%eax
 452:	74 72                	je     4c6 <caso3numpgs+0x96>
    close(fd[1]);
 454:	83 ec 0c             	sub    $0xc,%esp
 457:	ff 75 e0             	push   -0x20(%ebp)
    read(fd[0], answer, 20);
 45a:	8d 75 e4             	lea    -0x1c(%ebp),%esi
    close(fd[1]);
 45d:	e8 d9 06 00 00       	call   b3b <close>
    wait();
 462:	e8 b4 06 00 00       	call   b1b <wait>
    printf(stdout, "[--Caso 3.3] Parent lendo num_pages\n");
 467:	58                   	pop    %eax
 468:	5a                   	pop    %edx
 469:	68 a4 10 00 00       	push   $0x10a4
 46e:	ff 35 28 1a 00 00    	push   0x1a28
 474:	e8 17 08 00 00       	call   c90 <printf>
    read(fd[0], answer, 20);
 479:	83 c4 0c             	add    $0xc,%esp
 47c:	6a 14                	push   $0x14
 47e:	56                   	push   %esi
 47f:	ff 75 dc             	push   -0x24(%ebp)
 482:	e8 a4 06 00 00       	call   b2b <read>
    printf(stdout, "[--Caso 3.4] Parent leu %d == %d\n", np, atoi(answer));
 487:	89 34 24             	mov    %esi,(%esp)
 48a:	e8 11 06 00 00       	call   aa0 <atoi>
 48f:	50                   	push   %eax
 490:	53                   	push   %ebx
 491:	68 cc 10 00 00       	push   $0x10cc
 496:	ff 35 28 1a 00 00    	push   0x1a28
 49c:	e8 ef 07 00 00       	call   c90 <printf>
    close(fd[0]);
 4a1:	83 c4 14             	add    $0x14,%esp
 4a4:	ff 75 dc             	push   -0x24(%ebp)
 4a7:	e8 8f 06 00 00       	call   b3b <close>
    return atoi(answer) == np;
 4ac:	89 34 24             	mov    %esi,(%esp)
 4af:	e8 ec 05 00 00       	call   aa0 <atoi>
 4b4:	83 c4 10             	add    $0x10,%esp
 4b7:	39 d8                	cmp    %ebx,%eax
 4b9:	0f 94 c0             	sete   %al
}
 4bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
 4bf:	5b                   	pop    %ebx
    return atoi(answer) == np;
 4c0:	0f b6 c0             	movzbl %al,%eax
}
 4c3:	5e                   	pop    %esi
 4c4:	5d                   	pop    %ebp
 4c5:	c3                   	ret    
    printf(stdout, "[--Caso 3.1] Child write num_pages %d\n", num_pages());
 4c6:	e8 f8 06 00 00       	call   bc3 <num_pages>
 4cb:	51                   	push   %ecx
 4cc:	50                   	push   %eax
 4cd:	68 5c 10 00 00       	push   $0x105c
 4d2:	ff 35 28 1a 00 00    	push   0x1a28
 4d8:	e8 b3 07 00 00       	call   c90 <printf>
    close(fd[0]);
 4dd:	5b                   	pop    %ebx
 4de:	ff 75 dc             	push   -0x24(%ebp)
 4e1:	e8 55 06 00 00       	call   b3b <close>
    printf(fd[1], "%d\0", num_pages());
 4e6:	e8 d8 06 00 00       	call   bc3 <num_pages>
 4eb:	83 c4 0c             	add    $0xc,%esp
 4ee:	50                   	push   %eax
 4ef:	68 1c 13 00 00       	push   $0x131c
 4f4:	ff 75 e0             	push   -0x20(%ebp)
 4f7:	e8 94 07 00 00       	call   c90 <printf>
    printf(stdout, "[--Caso 3.2] Child indo embora\n");
 4fc:	5e                   	pop    %esi
 4fd:	58                   	pop    %eax
 4fe:	68 84 10 00 00       	push   $0x1084
 503:	ff 35 28 1a 00 00    	push   0x1a28
 509:	e8 82 07 00 00       	call   c90 <printf>
    close(fd[1]);
 50e:	58                   	pop    %eax
 50f:	ff 75 e0             	push   -0x20(%ebp)
 512:	e8 24 06 00 00       	call   b3b <close>
    exit();
 517:	e8 f7 05 00 00       	call   b13 <exit>
 51c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000520 <caso4mesmoaddr>:
int caso4mesmoaddr(void) {
 520:	55                   	push   %ebp
 521:	89 e5                	mov    %esp,%ebp
 523:	56                   	push   %esi
 524:	53                   	push   %ebx
  pipe(fd);
 525:	8d 45 dc             	lea    -0x24(%ebp),%eax
int caso4mesmoaddr(void) {
 528:	83 ec 2c             	sub    $0x2c,%esp
  pipe(fd);
 52b:	50                   	push   %eax
 52c:	e8 f2 05 00 00       	call   b23 <pipe>
  int pid = forkcow();
 531:	e8 95 06 00 00       	call   bcb <forkcow>
  if (pid == 0) { // child manda addr de GLOBAL1_RO
 536:	83 c4 10             	add    $0x10,%esp
 539:	85 c0                	test   %eax,%eax
 53b:	0f 84 84 00 00 00    	je     5c5 <caso4mesmoaddr+0xa5>
    int addr = (int)virt2real((char*)&GLOBAL1_RO);
 541:	83 ec 0c             	sub    $0xc,%esp
    read(fd[0], answer, 20);
 544:	8d 75 e4             	lea    -0x1c(%ebp),%esi
    int addr = (int)virt2real((char*)&GLOBAL1_RO);
 547:	68 20 13 00 00       	push   $0x1320
 54c:	e8 6a 06 00 00       	call   bbb <virt2real>
    if (addr < 0) addr = -addr; // atoi falha quando <0, nao sei pq
 551:	89 c3                	mov    %eax,%ebx
 553:	f7 db                	neg    %ebx
 555:	0f 48 d8             	cmovs  %eax,%ebx
    close(fd[1]);
 558:	58                   	pop    %eax
 559:	ff 75 e0             	push   -0x20(%ebp)
 55c:	e8 da 05 00 00       	call   b3b <close>
    wait();
 561:	e8 b5 05 00 00       	call   b1b <wait>
    printf(stdout, "[--Caso 4.3] Parent lendo addr\n");
 566:	5a                   	pop    %edx
 567:	59                   	pop    %ecx
 568:	68 10 11 00 00       	push   $0x1110
 56d:	ff 35 28 1a 00 00    	push   0x1a28
 573:	e8 18 07 00 00       	call   c90 <printf>
    read(fd[0], answer, 20);
 578:	83 c4 0c             	add    $0xc,%esp
 57b:	6a 14                	push   $0x14
 57d:	56                   	push   %esi
 57e:	ff 75 dc             	push   -0x24(%ebp)
 581:	e8 a5 05 00 00       	call   b2b <read>
    printf(stdout, "[--Caso 4.4] Parent leu %d == %d\n",
 586:	89 34 24             	mov    %esi,(%esp)
 589:	e8 12 05 00 00       	call   aa0 <atoi>
 58e:	50                   	push   %eax
 58f:	53                   	push   %ebx
 590:	68 30 11 00 00       	push   $0x1130
 595:	ff 35 28 1a 00 00    	push   0x1a28
 59b:	e8 f0 06 00 00       	call   c90 <printf>
    close(fd[0]);
 5a0:	83 c4 14             	add    $0x14,%esp
 5a3:	ff 75 dc             	push   -0x24(%ebp)
 5a6:	e8 90 05 00 00       	call   b3b <close>
    return addr == atoi(answer);
 5ab:	89 34 24             	mov    %esi,(%esp)
 5ae:	e8 ed 04 00 00       	call   aa0 <atoi>
 5b3:	83 c4 10             	add    $0x10,%esp
 5b6:	39 d8                	cmp    %ebx,%eax
 5b8:	0f 94 c0             	sete   %al
}
 5bb:	8d 65 f8             	lea    -0x8(%ebp),%esp
 5be:	5b                   	pop    %ebx
    return addr == atoi(answer);
 5bf:	0f b6 c0             	movzbl %al,%eax
}
 5c2:	5e                   	pop    %esi
 5c3:	5d                   	pop    %ebp
 5c4:	c3                   	ret    
    int addr = (int)virt2real((char*)&GLOBAL1_RO);
 5c5:	83 ec 0c             	sub    $0xc,%esp
 5c8:	68 20 13 00 00       	push   $0x1320
 5cd:	e8 e9 05 00 00       	call   bbb <virt2real>
    if (addr < 0) addr = -addr; // atoi falha quando <0, nao sei pq
 5d2:	83 c4 0c             	add    $0xc,%esp
 5d5:	89 c3                	mov    %eax,%ebx
 5d7:	f7 db                	neg    %ebx
 5d9:	0f 48 d8             	cmovs  %eax,%ebx
    printf(stdout, "[--Caso 4.1] Child write %d\n", addr);
 5dc:	53                   	push   %ebx
 5dd:	68 24 13 00 00       	push   $0x1324
 5e2:	ff 35 28 1a 00 00    	push   0x1a28
 5e8:	e8 a3 06 00 00       	call   c90 <printf>
    close(fd[0]);
 5ed:	5e                   	pop    %esi
 5ee:	ff 75 dc             	push   -0x24(%ebp)
 5f1:	e8 45 05 00 00       	call   b3b <close>
    printf(fd[1], "%d\0", addr);
 5f6:	83 c4 0c             	add    $0xc,%esp
 5f9:	53                   	push   %ebx
 5fa:	68 1c 13 00 00       	push   $0x131c
 5ff:	ff 75 e0             	push   -0x20(%ebp)
 602:	e8 89 06 00 00       	call   c90 <printf>
    printf(stdout, "[--Caso 4.2] Child indo embora\n");
 607:	58                   	pop    %eax
 608:	5a                   	pop    %edx
 609:	68 f0 10 00 00       	push   $0x10f0
 60e:	ff 35 28 1a 00 00    	push   0x1a28
 614:	e8 77 06 00 00       	call   c90 <printf>
    close(fd[1]);
 619:	59                   	pop    %ecx
 61a:	ff 75 e0             	push   -0x20(%ebp)
 61d:	e8 19 05 00 00       	call   b3b <close>
    exit();
 622:	e8 ec 04 00 00       	call   b13 <exit>
 627:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 62e:	66 90                	xchg   %ax,%ax

00000630 <caso5mesmoaddr>:
int caso5mesmoaddr(void) {
 630:	55                   	push   %ebp
 631:	89 e5                	mov    %esp,%ebp
 633:	56                   	push   %esi
 634:	53                   	push   %ebx
  pipe(fd);
 635:	8d 45 dc             	lea    -0x24(%ebp),%eax
int caso5mesmoaddr(void) {
 638:	83 ec 2c             	sub    $0x2c,%esp
  pipe(fd);
 63b:	50                   	push   %eax
 63c:	e8 e2 04 00 00       	call   b23 <pipe>
  int pid = forkcow();
 641:	e8 85 05 00 00       	call   bcb <forkcow>
  if (pid == 0) { // child manda addr de GLOBAL1_RO
 646:	83 c4 10             	add    $0x10,%esp
 649:	85 c0                	test   %eax,%eax
 64b:	0f 84 84 00 00 00    	je     6d5 <caso5mesmoaddr+0xa5>
    int addr = (int)virt2real((char*)&GLOBAL2_RW);
 651:	83 ec 0c             	sub    $0xc,%esp
    read(fd[0], answer, 20);
 654:	8d 75 e4             	lea    -0x1c(%ebp),%esi
    int addr = (int)virt2real((char*)&GLOBAL2_RW);
 657:	68 20 1a 00 00       	push   $0x1a20
 65c:	e8 5a 05 00 00       	call   bbb <virt2real>
    if (addr < 0) addr = -addr; // atoi falha quando <0, nao sei pq
 661:	89 c3                	mov    %eax,%ebx
 663:	f7 db                	neg    %ebx
 665:	0f 48 d8             	cmovs  %eax,%ebx
    close(fd[1]);
 668:	58                   	pop    %eax
 669:	ff 75 e0             	push   -0x20(%ebp)
 66c:	e8 ca 04 00 00       	call   b3b <close>
    wait();
 671:	e8 a5 04 00 00       	call   b1b <wait>
    printf(stdout, "[--Caso 5.3] Parent lendo addr\n");
 676:	5a                   	pop    %edx
 677:	59                   	pop    %ecx
 678:	68 74 11 00 00       	push   $0x1174
 67d:	ff 35 28 1a 00 00    	push   0x1a28
 683:	e8 08 06 00 00       	call   c90 <printf>
    read(fd[0], answer, 20);
 688:	83 c4 0c             	add    $0xc,%esp
 68b:	6a 14                	push   $0x14
 68d:	56                   	push   %esi
 68e:	ff 75 dc             	push   -0x24(%ebp)
 691:	e8 95 04 00 00       	call   b2b <read>
    printf(stdout, "[--Caso 5.4] Parent leu %d == %d\n",
 696:	89 34 24             	mov    %esi,(%esp)
 699:	e8 02 04 00 00       	call   aa0 <atoi>
 69e:	50                   	push   %eax
 69f:	53                   	push   %ebx
 6a0:	68 94 11 00 00       	push   $0x1194
 6a5:	ff 35 28 1a 00 00    	push   0x1a28
 6ab:	e8 e0 05 00 00       	call   c90 <printf>
    close(fd[0]);
 6b0:	83 c4 14             	add    $0x14,%esp
 6b3:	ff 75 dc             	push   -0x24(%ebp)
 6b6:	e8 80 04 00 00       	call   b3b <close>
    return addr == atoi(answer);
 6bb:	89 34 24             	mov    %esi,(%esp)
 6be:	e8 dd 03 00 00       	call   aa0 <atoi>
 6c3:	83 c4 10             	add    $0x10,%esp
 6c6:	39 d8                	cmp    %ebx,%eax
 6c8:	0f 94 c0             	sete   %al
}
 6cb:	8d 65 f8             	lea    -0x8(%ebp),%esp
 6ce:	5b                   	pop    %ebx
    return addr == atoi(answer);
 6cf:	0f b6 c0             	movzbl %al,%eax
}
 6d2:	5e                   	pop    %esi
 6d3:	5d                   	pop    %ebp
 6d4:	c3                   	ret    
    int addr = (int)virt2real((char*)&GLOBAL2_RW);
 6d5:	83 ec 0c             	sub    $0xc,%esp
 6d8:	68 20 1a 00 00       	push   $0x1a20
 6dd:	e8 d9 04 00 00       	call   bbb <virt2real>
    if (addr < 0) addr = -addr; // atoi falha quando <0, nao sei pq
 6e2:	83 c4 0c             	add    $0xc,%esp
 6e5:	89 c3                	mov    %eax,%ebx
 6e7:	f7 db                	neg    %ebx
 6e9:	0f 48 d8             	cmovs  %eax,%ebx
    printf(stdout, "[--Caso 5.1] Child write %d\n", addr);
 6ec:	53                   	push   %ebx
 6ed:	68 41 13 00 00       	push   $0x1341
 6f2:	ff 35 28 1a 00 00    	push   0x1a28
 6f8:	e8 93 05 00 00       	call   c90 <printf>
    close(fd[0]);
 6fd:	5e                   	pop    %esi
 6fe:	ff 75 dc             	push   -0x24(%ebp)
 701:	e8 35 04 00 00       	call   b3b <close>
    printf(fd[1], "%d\0", addr);
 706:	83 c4 0c             	add    $0xc,%esp
 709:	53                   	push   %ebx
 70a:	68 1c 13 00 00       	push   $0x131c
 70f:	ff 75 e0             	push   -0x20(%ebp)
 712:	e8 79 05 00 00       	call   c90 <printf>
    printf(stdout, "[--Caso 5.2] Child indo embora\n");
 717:	58                   	pop    %eax
 718:	5a                   	pop    %edx
 719:	68 54 11 00 00       	push   $0x1154
 71e:	ff 35 28 1a 00 00    	push   0x1a28
 724:	e8 67 05 00 00       	call   c90 <printf>
    close(fd[1]);
 729:	59                   	pop    %ecx
 72a:	ff 75 e0             	push   -0x20(%ebp)
 72d:	e8 09 04 00 00       	call   b3b <close>
    exit();
 732:	e8 dc 03 00 00       	call   b13 <exit>
 737:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 73e:	66 90                	xchg   %ax,%ax

00000740 <caso6cow>:
int caso6cow(void) {
 740:	55                   	push   %ebp
 741:	89 e5                	mov    %esp,%ebp
 743:	56                   	push   %esi
 744:	53                   	push   %ebx
  pipe(fd);
 745:	8d 45 dc             	lea    -0x24(%ebp),%eax
int caso6cow(void) {
 748:	83 ec 2c             	sub    $0x2c,%esp
  pipe(fd);
 74b:	50                   	push   %eax
 74c:	e8 d2 03 00 00       	call   b23 <pipe>
  int pid = forkcow();
 751:	e8 75 04 00 00       	call   bcb <forkcow>
  if (pid == 0) { // child manda addr de GLOBAL2_RW
 756:	83 c4 10             	add    $0x10,%esp
 759:	85 c0                	test   %eax,%eax
 75b:	0f 84 84 00 00 00    	je     7e5 <caso6cow+0xa5>
    int addr = (int)virt2real((char*)&GLOBAL2_RW);
 761:	83 ec 0c             	sub    $0xc,%esp
    read(fd[0], answer, 20);
 764:	8d 75 e4             	lea    -0x1c(%ebp),%esi
    int addr = (int)virt2real((char*)&GLOBAL2_RW);
 767:	68 20 1a 00 00       	push   $0x1a20
 76c:	e8 4a 04 00 00       	call   bbb <virt2real>
    if (addr < 0) addr = -addr; // atoi falha quando <0, nao sei pq
 771:	89 c3                	mov    %eax,%ebx
 773:	f7 db                	neg    %ebx
 775:	0f 48 d8             	cmovs  %eax,%ebx
    close(fd[1]);
 778:	58                   	pop    %eax
 779:	ff 75 e0             	push   -0x20(%ebp)
 77c:	e8 ba 03 00 00       	call   b3b <close>
    wait();
 781:	e8 95 03 00 00       	call   b1b <wait>
    printf(stdout, "[--Caso 6.3] Parent lendo addr\n");
 786:	5a                   	pop    %edx
 787:	59                   	pop    %ecx
 788:	68 d8 11 00 00       	push   $0x11d8
 78d:	ff 35 28 1a 00 00    	push   0x1a28
 793:	e8 f8 04 00 00       	call   c90 <printf>
    read(fd[0], answer, 20);
 798:	83 c4 0c             	add    $0xc,%esp
 79b:	6a 14                	push   $0x14
 79d:	56                   	push   %esi
 79e:	ff 75 dc             	push   -0x24(%ebp)
 7a1:	e8 85 03 00 00       	call   b2b <read>
    printf(stdout, "[--Caso 6.4] Parent leu %d != %d\n",
 7a6:	89 34 24             	mov    %esi,(%esp)
 7a9:	e8 f2 02 00 00       	call   aa0 <atoi>
 7ae:	50                   	push   %eax
 7af:	53                   	push   %ebx
 7b0:	68 f8 11 00 00       	push   $0x11f8
 7b5:	ff 35 28 1a 00 00    	push   0x1a28
 7bb:	e8 d0 04 00 00       	call   c90 <printf>
    close(fd[0]);
 7c0:	83 c4 14             	add    $0x14,%esp
 7c3:	ff 75 dc             	push   -0x24(%ebp)
 7c6:	e8 70 03 00 00       	call   b3b <close>
    return addr != atoi(answer);
 7cb:	89 34 24             	mov    %esi,(%esp)
 7ce:	e8 cd 02 00 00       	call   aa0 <atoi>
 7d3:	83 c4 10             	add    $0x10,%esp
 7d6:	39 d8                	cmp    %ebx,%eax
 7d8:	0f 95 c0             	setne  %al
}
 7db:	8d 65 f8             	lea    -0x8(%ebp),%esp
 7de:	5b                   	pop    %ebx
    return addr != atoi(answer);
 7df:	0f b6 c0             	movzbl %al,%eax
}
 7e2:	5e                   	pop    %esi
 7e3:	5d                   	pop    %ebp
 7e4:	c3                   	ret    
    int addr = (int)virt2real((char*)&GLOBAL2_RW);
 7e5:	83 ec 0c             	sub    $0xc,%esp
    GLOBAL2_RW--;
 7e8:	83 2d 20 1a 00 00 01 	subl   $0x1,0x1a20
    int addr = (int)virt2real((char*)&GLOBAL2_RW);
 7ef:	68 20 1a 00 00       	push   $0x1a20
 7f4:	e8 c2 03 00 00       	call   bbb <virt2real>
    if (addr < 0) addr = -addr; // atoi falha quando <0, nao sei pq
 7f9:	83 c4 0c             	add    $0xc,%esp
 7fc:	89 c3                	mov    %eax,%ebx
 7fe:	f7 db                	neg    %ebx
 800:	0f 48 d8             	cmovs  %eax,%ebx
    printf(stdout, "[--Caso 6.1] Child write %d\n", addr);
 803:	53                   	push   %ebx
 804:	68 5e 13 00 00       	push   $0x135e
 809:	ff 35 28 1a 00 00    	push   0x1a28
 80f:	e8 7c 04 00 00       	call   c90 <printf>
    close(fd[0]);
 814:	5e                   	pop    %esi
 815:	ff 75 dc             	push   -0x24(%ebp)
 818:	e8 1e 03 00 00       	call   b3b <close>
    printf(fd[1], "%d\0", addr);
 81d:	83 c4 0c             	add    $0xc,%esp
 820:	53                   	push   %ebx
 821:	68 1c 13 00 00       	push   $0x131c
 826:	ff 75 e0             	push   -0x20(%ebp)
 829:	e8 62 04 00 00       	call   c90 <printf>
    printf(stdout, "[--Caso 6.2] Child indo embora\n");
 82e:	58                   	pop    %eax
 82f:	5a                   	pop    %edx
 830:	68 b8 11 00 00       	push   $0x11b8
 835:	ff 35 28 1a 00 00    	push   0x1a28
 83b:	e8 50 04 00 00       	call   c90 <printf>
    close(fd[1]);
 840:	59                   	pop    %ecx
 841:	ff 75 e0             	push   -0x20(%ebp)
 844:	e8 f2 02 00 00       	call   b3b <close>
    exit();
 849:	e8 c5 02 00 00       	call   b13 <exit>
 84e:	66 90                	xchg   %ax,%ax

00000850 <get_date>:
int get_date(struct rtcdate *r) {
 850:	55                   	push   %ebp
 851:	89 e5                	mov    %esp,%ebp
 853:	83 ec 14             	sub    $0x14,%esp
  if (date(r)) {
 856:	ff 75 08             	push   0x8(%ebp)
 859:	e8 55 03 00 00       	call   bb3 <date>
 85e:	83 c4 10             	add    $0x10,%esp
 861:	89 c2                	mov    %eax,%edx
 863:	b8 01 00 00 00       	mov    $0x1,%eax
 868:	85 d2                	test   %edx,%edx
 86a:	75 04                	jne    870 <get_date+0x20>
}
 86c:	c9                   	leave  
 86d:	c3                   	ret    
 86e:	66 90                	xchg   %ax,%ax
    printf(stderr, "[ERROR] Erro na chamada de sistema date\n");
 870:	83 ec 08             	sub    $0x8,%esp
 873:	68 1c 12 00 00       	push   $0x121c
 878:	ff 35 24 1a 00 00    	push   0x1a24
 87e:	e8 0d 04 00 00       	call   c90 <printf>
 883:	83 c4 10             	add    $0x10,%esp
 886:	31 c0                	xor    %eax,%eax
}
 888:	c9                   	leave  
 889:	c3                   	ret    
 88a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000890 <print_date>:
void print_date(struct rtcdate *r) {
 890:	55                   	push   %ebp
 891:	89 e5                	mov    %esp,%ebp
 893:	83 ec 08             	sub    $0x8,%esp
 896:	8b 45 08             	mov    0x8(%ebp),%eax
  printf(stdout, "%d/%d/%d %d:%d:%d\n", r->day,
 899:	ff 30                	push   (%eax)
 89b:	ff 70 04             	push   0x4(%eax)
 89e:	ff 70 08             	push   0x8(%eax)
 8a1:	ff 70 14             	push   0x14(%eax)
 8a4:	ff 70 10             	push   0x10(%eax)
 8a7:	ff 70 0c             	push   0xc(%eax)
 8aa:	68 7b 13 00 00       	push   $0x137b
 8af:	ff 35 28 1a 00 00    	push   0x1a28
 8b5:	e8 d6 03 00 00       	call   c90 <printf>
}
 8ba:	83 c4 20             	add    $0x20,%esp
 8bd:	c9                   	leave  
 8be:	c3                   	ret    
 8bf:	90                   	nop

000008c0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 8c0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 8c1:	31 c0                	xor    %eax,%eax
{
 8c3:	89 e5                	mov    %esp,%ebp
 8c5:	53                   	push   %ebx
 8c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
 8c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 8cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 8d0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 8d4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 8d7:	83 c0 01             	add    $0x1,%eax
 8da:	84 d2                	test   %dl,%dl
 8dc:	75 f2                	jne    8d0 <strcpy+0x10>
    ;
  return os;
}
 8de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 8e1:	89 c8                	mov    %ecx,%eax
 8e3:	c9                   	leave  
 8e4:	c3                   	ret    
 8e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000008f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 8f0:	55                   	push   %ebp
 8f1:	89 e5                	mov    %esp,%ebp
 8f3:	53                   	push   %ebx
 8f4:	8b 55 08             	mov    0x8(%ebp),%edx
 8f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 8fa:	0f b6 02             	movzbl (%edx),%eax
 8fd:	84 c0                	test   %al,%al
 8ff:	75 17                	jne    918 <strcmp+0x28>
 901:	eb 3a                	jmp    93d <strcmp+0x4d>
 903:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 907:	90                   	nop
 908:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 90c:	83 c2 01             	add    $0x1,%edx
 90f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 912:	84 c0                	test   %al,%al
 914:	74 1a                	je     930 <strcmp+0x40>
    p++, q++;
 916:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
 918:	0f b6 19             	movzbl (%ecx),%ebx
 91b:	38 c3                	cmp    %al,%bl
 91d:	74 e9                	je     908 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 91f:	29 d8                	sub    %ebx,%eax
}
 921:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 924:	c9                   	leave  
 925:	c3                   	ret    
 926:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 92d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 930:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 934:	31 c0                	xor    %eax,%eax
 936:	29 d8                	sub    %ebx,%eax
}
 938:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 93b:	c9                   	leave  
 93c:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
 93d:	0f b6 19             	movzbl (%ecx),%ebx
 940:	31 c0                	xor    %eax,%eax
 942:	eb db                	jmp    91f <strcmp+0x2f>
 944:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 94b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 94f:	90                   	nop

00000950 <strlen>:

uint
strlen(const char *s)
{
 950:	55                   	push   %ebp
 951:	89 e5                	mov    %esp,%ebp
 953:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 956:	80 3a 00             	cmpb   $0x0,(%edx)
 959:	74 15                	je     970 <strlen+0x20>
 95b:	31 c0                	xor    %eax,%eax
 95d:	8d 76 00             	lea    0x0(%esi),%esi
 960:	83 c0 01             	add    $0x1,%eax
 963:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 967:	89 c1                	mov    %eax,%ecx
 969:	75 f5                	jne    960 <strlen+0x10>
    ;
  return n;
}
 96b:	89 c8                	mov    %ecx,%eax
 96d:	5d                   	pop    %ebp
 96e:	c3                   	ret    
 96f:	90                   	nop
  for(n = 0; s[n]; n++)
 970:	31 c9                	xor    %ecx,%ecx
}
 972:	5d                   	pop    %ebp
 973:	89 c8                	mov    %ecx,%eax
 975:	c3                   	ret    
 976:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 97d:	8d 76 00             	lea    0x0(%esi),%esi

00000980 <memset>:

void*
memset(void *dst, int c, uint n)
{
 980:	55                   	push   %ebp
 981:	89 e5                	mov    %esp,%ebp
 983:	57                   	push   %edi
 984:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 987:	8b 4d 10             	mov    0x10(%ebp),%ecx
 98a:	8b 45 0c             	mov    0xc(%ebp),%eax
 98d:	89 d7                	mov    %edx,%edi
 98f:	fc                   	cld    
 990:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 992:	8b 7d fc             	mov    -0x4(%ebp),%edi
 995:	89 d0                	mov    %edx,%eax
 997:	c9                   	leave  
 998:	c3                   	ret    
 999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000009a0 <strchr>:

char*
strchr(const char *s, char c)
{
 9a0:	55                   	push   %ebp
 9a1:	89 e5                	mov    %esp,%ebp
 9a3:	8b 45 08             	mov    0x8(%ebp),%eax
 9a6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 9aa:	0f b6 10             	movzbl (%eax),%edx
 9ad:	84 d2                	test   %dl,%dl
 9af:	75 12                	jne    9c3 <strchr+0x23>
 9b1:	eb 1d                	jmp    9d0 <strchr+0x30>
 9b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 9b7:	90                   	nop
 9b8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 9bc:	83 c0 01             	add    $0x1,%eax
 9bf:	84 d2                	test   %dl,%dl
 9c1:	74 0d                	je     9d0 <strchr+0x30>
    if(*s == c)
 9c3:	38 d1                	cmp    %dl,%cl
 9c5:	75 f1                	jne    9b8 <strchr+0x18>
      return (char*)s;
  return 0;
}
 9c7:	5d                   	pop    %ebp
 9c8:	c3                   	ret    
 9c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 9d0:	31 c0                	xor    %eax,%eax
}
 9d2:	5d                   	pop    %ebp
 9d3:	c3                   	ret    
 9d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 9db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 9df:	90                   	nop

000009e0 <gets>:

char*
gets(char *buf, int max)
{
 9e0:	55                   	push   %ebp
 9e1:	89 e5                	mov    %esp,%ebp
 9e3:	57                   	push   %edi
 9e4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 9e5:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 9e8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 9e9:	31 db                	xor    %ebx,%ebx
{
 9eb:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 9ee:	eb 27                	jmp    a17 <gets+0x37>
    cc = read(0, &c, 1);
 9f0:	83 ec 04             	sub    $0x4,%esp
 9f3:	6a 01                	push   $0x1
 9f5:	57                   	push   %edi
 9f6:	6a 00                	push   $0x0
 9f8:	e8 2e 01 00 00       	call   b2b <read>
    if(cc < 1)
 9fd:	83 c4 10             	add    $0x10,%esp
 a00:	85 c0                	test   %eax,%eax
 a02:	7e 1d                	jle    a21 <gets+0x41>
      break;
    buf[i++] = c;
 a04:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 a08:	8b 55 08             	mov    0x8(%ebp),%edx
 a0b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 a0f:	3c 0a                	cmp    $0xa,%al
 a11:	74 1d                	je     a30 <gets+0x50>
 a13:	3c 0d                	cmp    $0xd,%al
 a15:	74 19                	je     a30 <gets+0x50>
  for(i=0; i+1 < max; ){
 a17:	89 de                	mov    %ebx,%esi
 a19:	83 c3 01             	add    $0x1,%ebx
 a1c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 a1f:	7c cf                	jl     9f0 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 a21:	8b 45 08             	mov    0x8(%ebp),%eax
 a24:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 a28:	8d 65 f4             	lea    -0xc(%ebp),%esp
 a2b:	5b                   	pop    %ebx
 a2c:	5e                   	pop    %esi
 a2d:	5f                   	pop    %edi
 a2e:	5d                   	pop    %ebp
 a2f:	c3                   	ret    
  buf[i] = '\0';
 a30:	8b 45 08             	mov    0x8(%ebp),%eax
 a33:	89 de                	mov    %ebx,%esi
 a35:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 a39:	8d 65 f4             	lea    -0xc(%ebp),%esp
 a3c:	5b                   	pop    %ebx
 a3d:	5e                   	pop    %esi
 a3e:	5f                   	pop    %edi
 a3f:	5d                   	pop    %ebp
 a40:	c3                   	ret    
 a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a4f:	90                   	nop

00000a50 <stat>:

int
stat(const char *n, struct stat *st)
{
 a50:	55                   	push   %ebp
 a51:	89 e5                	mov    %esp,%ebp
 a53:	56                   	push   %esi
 a54:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 a55:	83 ec 08             	sub    $0x8,%esp
 a58:	6a 00                	push   $0x0
 a5a:	ff 75 08             	push   0x8(%ebp)
 a5d:	e8 f1 00 00 00       	call   b53 <open>
  if(fd < 0)
 a62:	83 c4 10             	add    $0x10,%esp
 a65:	85 c0                	test   %eax,%eax
 a67:	78 27                	js     a90 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 a69:	83 ec 08             	sub    $0x8,%esp
 a6c:	ff 75 0c             	push   0xc(%ebp)
 a6f:	89 c3                	mov    %eax,%ebx
 a71:	50                   	push   %eax
 a72:	e8 f4 00 00 00       	call   b6b <fstat>
  close(fd);
 a77:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 a7a:	89 c6                	mov    %eax,%esi
  close(fd);
 a7c:	e8 ba 00 00 00       	call   b3b <close>
  return r;
 a81:	83 c4 10             	add    $0x10,%esp
}
 a84:	8d 65 f8             	lea    -0x8(%ebp),%esp
 a87:	89 f0                	mov    %esi,%eax
 a89:	5b                   	pop    %ebx
 a8a:	5e                   	pop    %esi
 a8b:	5d                   	pop    %ebp
 a8c:	c3                   	ret    
 a8d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 a90:	be ff ff ff ff       	mov    $0xffffffff,%esi
 a95:	eb ed                	jmp    a84 <stat+0x34>
 a97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a9e:	66 90                	xchg   %ax,%ax

00000aa0 <atoi>:

int
atoi(const char *s)
{
 aa0:	55                   	push   %ebp
 aa1:	89 e5                	mov    %esp,%ebp
 aa3:	53                   	push   %ebx
 aa4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 aa7:	0f be 02             	movsbl (%edx),%eax
 aaa:	8d 48 d0             	lea    -0x30(%eax),%ecx
 aad:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 ab0:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 ab5:	77 1e                	ja     ad5 <atoi+0x35>
 ab7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 abe:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 ac0:	83 c2 01             	add    $0x1,%edx
 ac3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 ac6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 aca:	0f be 02             	movsbl (%edx),%eax
 acd:	8d 58 d0             	lea    -0x30(%eax),%ebx
 ad0:	80 fb 09             	cmp    $0x9,%bl
 ad3:	76 eb                	jbe    ac0 <atoi+0x20>
  return n;
}
 ad5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 ad8:	89 c8                	mov    %ecx,%eax
 ada:	c9                   	leave  
 adb:	c3                   	ret    
 adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000ae0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 ae0:	55                   	push   %ebp
 ae1:	89 e5                	mov    %esp,%ebp
 ae3:	57                   	push   %edi
 ae4:	8b 45 10             	mov    0x10(%ebp),%eax
 ae7:	8b 55 08             	mov    0x8(%ebp),%edx
 aea:	56                   	push   %esi
 aeb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 aee:	85 c0                	test   %eax,%eax
 af0:	7e 13                	jle    b05 <memmove+0x25>
 af2:	01 d0                	add    %edx,%eax
  dst = vdst;
 af4:	89 d7                	mov    %edx,%edi
 af6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 afd:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 b00:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 b01:	39 f8                	cmp    %edi,%eax
 b03:	75 fb                	jne    b00 <memmove+0x20>
  return vdst;
}
 b05:	5e                   	pop    %esi
 b06:	89 d0                	mov    %edx,%eax
 b08:	5f                   	pop    %edi
 b09:	5d                   	pop    %ebp
 b0a:	c3                   	ret    

00000b0b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 b0b:	b8 01 00 00 00       	mov    $0x1,%eax
 b10:	cd 40                	int    $0x40
 b12:	c3                   	ret    

00000b13 <exit>:
SYSCALL(exit)
 b13:	b8 02 00 00 00       	mov    $0x2,%eax
 b18:	cd 40                	int    $0x40
 b1a:	c3                   	ret    

00000b1b <wait>:
SYSCALL(wait)
 b1b:	b8 03 00 00 00       	mov    $0x3,%eax
 b20:	cd 40                	int    $0x40
 b22:	c3                   	ret    

00000b23 <pipe>:
SYSCALL(pipe)
 b23:	b8 04 00 00 00       	mov    $0x4,%eax
 b28:	cd 40                	int    $0x40
 b2a:	c3                   	ret    

00000b2b <read>:
SYSCALL(read)
 b2b:	b8 05 00 00 00       	mov    $0x5,%eax
 b30:	cd 40                	int    $0x40
 b32:	c3                   	ret    

00000b33 <write>:
SYSCALL(write)
 b33:	b8 10 00 00 00       	mov    $0x10,%eax
 b38:	cd 40                	int    $0x40
 b3a:	c3                   	ret    

00000b3b <close>:
SYSCALL(close)
 b3b:	b8 15 00 00 00       	mov    $0x15,%eax
 b40:	cd 40                	int    $0x40
 b42:	c3                   	ret    

00000b43 <kill>:
SYSCALL(kill)
 b43:	b8 06 00 00 00       	mov    $0x6,%eax
 b48:	cd 40                	int    $0x40
 b4a:	c3                   	ret    

00000b4b <exec>:
SYSCALL(exec)
 b4b:	b8 07 00 00 00       	mov    $0x7,%eax
 b50:	cd 40                	int    $0x40
 b52:	c3                   	ret    

00000b53 <open>:
SYSCALL(open)
 b53:	b8 0f 00 00 00       	mov    $0xf,%eax
 b58:	cd 40                	int    $0x40
 b5a:	c3                   	ret    

00000b5b <mknod>:
SYSCALL(mknod)
 b5b:	b8 11 00 00 00       	mov    $0x11,%eax
 b60:	cd 40                	int    $0x40
 b62:	c3                   	ret    

00000b63 <unlink>:
SYSCALL(unlink)
 b63:	b8 12 00 00 00       	mov    $0x12,%eax
 b68:	cd 40                	int    $0x40
 b6a:	c3                   	ret    

00000b6b <fstat>:
SYSCALL(fstat)
 b6b:	b8 08 00 00 00       	mov    $0x8,%eax
 b70:	cd 40                	int    $0x40
 b72:	c3                   	ret    

00000b73 <link>:
SYSCALL(link)
 b73:	b8 13 00 00 00       	mov    $0x13,%eax
 b78:	cd 40                	int    $0x40
 b7a:	c3                   	ret    

00000b7b <mkdir>:
SYSCALL(mkdir)
 b7b:	b8 14 00 00 00       	mov    $0x14,%eax
 b80:	cd 40                	int    $0x40
 b82:	c3                   	ret    

00000b83 <chdir>:
SYSCALL(chdir)
 b83:	b8 09 00 00 00       	mov    $0x9,%eax
 b88:	cd 40                	int    $0x40
 b8a:	c3                   	ret    

00000b8b <dup>:
SYSCALL(dup)
 b8b:	b8 0a 00 00 00       	mov    $0xa,%eax
 b90:	cd 40                	int    $0x40
 b92:	c3                   	ret    

00000b93 <getpid>:
SYSCALL(getpid)
 b93:	b8 0b 00 00 00       	mov    $0xb,%eax
 b98:	cd 40                	int    $0x40
 b9a:	c3                   	ret    

00000b9b <sbrk>:
SYSCALL(sbrk)
 b9b:	b8 0c 00 00 00       	mov    $0xc,%eax
 ba0:	cd 40                	int    $0x40
 ba2:	c3                   	ret    

00000ba3 <sleep>:
SYSCALL(sleep)
 ba3:	b8 0d 00 00 00       	mov    $0xd,%eax
 ba8:	cd 40                	int    $0x40
 baa:	c3                   	ret    

00000bab <uptime>:
SYSCALL(uptime)
 bab:	b8 0e 00 00 00       	mov    $0xe,%eax
 bb0:	cd 40                	int    $0x40
 bb2:	c3                   	ret    

00000bb3 <date>:
SYSCALL(date)
 bb3:	b8 16 00 00 00       	mov    $0x16,%eax
 bb8:	cd 40                	int    $0x40
 bba:	c3                   	ret    

00000bbb <virt2real>:
SYSCALL(virt2real)
 bbb:	b8 17 00 00 00       	mov    $0x17,%eax
 bc0:	cd 40                	int    $0x40
 bc2:	c3                   	ret    

00000bc3 <num_pages>:
SYSCALL(num_pages)
 bc3:	b8 18 00 00 00       	mov    $0x18,%eax
 bc8:	cd 40                	int    $0x40
 bca:	c3                   	ret    

00000bcb <forkcow>:
SYSCALL(forkcow)
 bcb:	b8 19 00 00 00       	mov    $0x19,%eax
 bd0:	cd 40                	int    $0x40
 bd2:	c3                   	ret    
 bd3:	66 90                	xchg   %ax,%ax
 bd5:	66 90                	xchg   %ax,%ax
 bd7:	66 90                	xchg   %ax,%ax
 bd9:	66 90                	xchg   %ax,%ax
 bdb:	66 90                	xchg   %ax,%ax
 bdd:	66 90                	xchg   %ax,%ax
 bdf:	90                   	nop

00000be0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 be0:	55                   	push   %ebp
 be1:	89 e5                	mov    %esp,%ebp
 be3:	57                   	push   %edi
 be4:	56                   	push   %esi
 be5:	53                   	push   %ebx
 be6:	83 ec 3c             	sub    $0x3c,%esp
 be9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 bec:	89 d1                	mov    %edx,%ecx
{
 bee:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 bf1:	85 d2                	test   %edx,%edx
 bf3:	0f 89 7f 00 00 00    	jns    c78 <printint+0x98>
 bf9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 bfd:	74 79                	je     c78 <printint+0x98>
    neg = 1;
 bff:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 c06:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 c08:	31 db                	xor    %ebx,%ebx
 c0a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 c0d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 c10:	89 c8                	mov    %ecx,%eax
 c12:	31 d2                	xor    %edx,%edx
 c14:	89 cf                	mov    %ecx,%edi
 c16:	f7 75 c4             	divl   -0x3c(%ebp)
 c19:	0f b6 92 0c 16 00 00 	movzbl 0x160c(%edx),%edx
 c20:	89 45 c0             	mov    %eax,-0x40(%ebp)
 c23:	89 d8                	mov    %ebx,%eax
 c25:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 c28:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 c2b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 c2e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 c31:	76 dd                	jbe    c10 <printint+0x30>
  if(neg)
 c33:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 c36:	85 c9                	test   %ecx,%ecx
 c38:	74 0c                	je     c46 <printint+0x66>
    buf[i++] = '-';
 c3a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 c3f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 c41:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 c46:	8b 7d b8             	mov    -0x48(%ebp),%edi
 c49:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 c4d:	eb 07                	jmp    c56 <printint+0x76>
 c4f:	90                   	nop
    putc(fd, buf[i]);
 c50:	0f b6 13             	movzbl (%ebx),%edx
 c53:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 c56:	83 ec 04             	sub    $0x4,%esp
 c59:	88 55 d7             	mov    %dl,-0x29(%ebp)
 c5c:	6a 01                	push   $0x1
 c5e:	56                   	push   %esi
 c5f:	57                   	push   %edi
 c60:	e8 ce fe ff ff       	call   b33 <write>
  while(--i >= 0)
 c65:	83 c4 10             	add    $0x10,%esp
 c68:	39 de                	cmp    %ebx,%esi
 c6a:	75 e4                	jne    c50 <printint+0x70>
}
 c6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 c6f:	5b                   	pop    %ebx
 c70:	5e                   	pop    %esi
 c71:	5f                   	pop    %edi
 c72:	5d                   	pop    %ebp
 c73:	c3                   	ret    
 c74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 c78:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 c7f:	eb 87                	jmp    c08 <printint+0x28>
 c81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 c88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 c8f:	90                   	nop

00000c90 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 c90:	55                   	push   %ebp
 c91:	89 e5                	mov    %esp,%ebp
 c93:	57                   	push   %edi
 c94:	56                   	push   %esi
 c95:	53                   	push   %ebx
 c96:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 c99:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 c9c:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 c9f:	0f b6 13             	movzbl (%ebx),%edx
 ca2:	84 d2                	test   %dl,%dl
 ca4:	74 6a                	je     d10 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 ca6:	8d 45 10             	lea    0x10(%ebp),%eax
 ca9:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 cac:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 caf:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 cb1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 cb4:	eb 36                	jmp    cec <printf+0x5c>
 cb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 cbd:	8d 76 00             	lea    0x0(%esi),%esi
 cc0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 cc3:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 cc8:	83 f8 25             	cmp    $0x25,%eax
 ccb:	74 15                	je     ce2 <printf+0x52>
  write(fd, &c, 1);
 ccd:	83 ec 04             	sub    $0x4,%esp
 cd0:	88 55 e7             	mov    %dl,-0x19(%ebp)
 cd3:	6a 01                	push   $0x1
 cd5:	57                   	push   %edi
 cd6:	56                   	push   %esi
 cd7:	e8 57 fe ff ff       	call   b33 <write>
 cdc:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 cdf:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 ce2:	0f b6 13             	movzbl (%ebx),%edx
 ce5:	83 c3 01             	add    $0x1,%ebx
 ce8:	84 d2                	test   %dl,%dl
 cea:	74 24                	je     d10 <printf+0x80>
    c = fmt[i] & 0xff;
 cec:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 cef:	85 c9                	test   %ecx,%ecx
 cf1:	74 cd                	je     cc0 <printf+0x30>
      }
    } else if(state == '%'){
 cf3:	83 f9 25             	cmp    $0x25,%ecx
 cf6:	75 ea                	jne    ce2 <printf+0x52>
      if(c == 'd'){
 cf8:	83 f8 25             	cmp    $0x25,%eax
 cfb:	0f 84 07 01 00 00    	je     e08 <printf+0x178>
 d01:	83 e8 63             	sub    $0x63,%eax
 d04:	83 f8 15             	cmp    $0x15,%eax
 d07:	77 17                	ja     d20 <printf+0x90>
 d09:	ff 24 85 b4 15 00 00 	jmp    *0x15b4(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 d10:	8d 65 f4             	lea    -0xc(%ebp),%esp
 d13:	5b                   	pop    %ebx
 d14:	5e                   	pop    %esi
 d15:	5f                   	pop    %edi
 d16:	5d                   	pop    %ebp
 d17:	c3                   	ret    
 d18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 d1f:	90                   	nop
  write(fd, &c, 1);
 d20:	83 ec 04             	sub    $0x4,%esp
 d23:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 d26:	6a 01                	push   $0x1
 d28:	57                   	push   %edi
 d29:	56                   	push   %esi
 d2a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 d2e:	e8 00 fe ff ff       	call   b33 <write>
        putc(fd, c);
 d33:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 d37:	83 c4 0c             	add    $0xc,%esp
 d3a:	88 55 e7             	mov    %dl,-0x19(%ebp)
 d3d:	6a 01                	push   $0x1
 d3f:	57                   	push   %edi
 d40:	56                   	push   %esi
 d41:	e8 ed fd ff ff       	call   b33 <write>
        putc(fd, c);
 d46:	83 c4 10             	add    $0x10,%esp
      state = 0;
 d49:	31 c9                	xor    %ecx,%ecx
 d4b:	eb 95                	jmp    ce2 <printf+0x52>
 d4d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 d50:	83 ec 0c             	sub    $0xc,%esp
 d53:	b9 10 00 00 00       	mov    $0x10,%ecx
 d58:	6a 00                	push   $0x0
 d5a:	8b 45 d0             	mov    -0x30(%ebp),%eax
 d5d:	8b 10                	mov    (%eax),%edx
 d5f:	89 f0                	mov    %esi,%eax
 d61:	e8 7a fe ff ff       	call   be0 <printint>
        ap++;
 d66:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 d6a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 d6d:	31 c9                	xor    %ecx,%ecx
 d6f:	e9 6e ff ff ff       	jmp    ce2 <printf+0x52>
 d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 d78:	8b 45 d0             	mov    -0x30(%ebp),%eax
 d7b:	8b 10                	mov    (%eax),%edx
        ap++;
 d7d:	83 c0 04             	add    $0x4,%eax
 d80:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 d83:	85 d2                	test   %edx,%edx
 d85:	0f 84 8d 00 00 00    	je     e18 <printf+0x188>
        while(*s != 0){
 d8b:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 d8e:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 d90:	84 c0                	test   %al,%al
 d92:	0f 84 4a ff ff ff    	je     ce2 <printf+0x52>
 d98:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 d9b:	89 d3                	mov    %edx,%ebx
 d9d:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 da0:	83 ec 04             	sub    $0x4,%esp
          s++;
 da3:	83 c3 01             	add    $0x1,%ebx
 da6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 da9:	6a 01                	push   $0x1
 dab:	57                   	push   %edi
 dac:	56                   	push   %esi
 dad:	e8 81 fd ff ff       	call   b33 <write>
        while(*s != 0){
 db2:	0f b6 03             	movzbl (%ebx),%eax
 db5:	83 c4 10             	add    $0x10,%esp
 db8:	84 c0                	test   %al,%al
 dba:	75 e4                	jne    da0 <printf+0x110>
      state = 0;
 dbc:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 dbf:	31 c9                	xor    %ecx,%ecx
 dc1:	e9 1c ff ff ff       	jmp    ce2 <printf+0x52>
 dc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 dcd:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 dd0:	83 ec 0c             	sub    $0xc,%esp
 dd3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 dd8:	6a 01                	push   $0x1
 dda:	e9 7b ff ff ff       	jmp    d5a <printf+0xca>
 ddf:	90                   	nop
        putc(fd, *ap);
 de0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 de3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 de6:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 de8:	6a 01                	push   $0x1
 dea:	57                   	push   %edi
 deb:	56                   	push   %esi
        putc(fd, *ap);
 dec:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 def:	e8 3f fd ff ff       	call   b33 <write>
        ap++;
 df4:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 df8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 dfb:	31 c9                	xor    %ecx,%ecx
 dfd:	e9 e0 fe ff ff       	jmp    ce2 <printf+0x52>
 e02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
 e08:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 e0b:	83 ec 04             	sub    $0x4,%esp
 e0e:	e9 2a ff ff ff       	jmp    d3d <printf+0xad>
 e13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 e17:	90                   	nop
          s = "(null)";
 e18:	ba ac 15 00 00       	mov    $0x15ac,%edx
        while(*s != 0){
 e1d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 e20:	b8 28 00 00 00       	mov    $0x28,%eax
 e25:	89 d3                	mov    %edx,%ebx
 e27:	e9 74 ff ff ff       	jmp    da0 <printf+0x110>
 e2c:	66 90                	xchg   %ax,%ax
 e2e:	66 90                	xchg   %ax,%ax

00000e30 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 e30:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 e31:	a1 2c 1a 00 00       	mov    0x1a2c,%eax
{
 e36:	89 e5                	mov    %esp,%ebp
 e38:	57                   	push   %edi
 e39:	56                   	push   %esi
 e3a:	53                   	push   %ebx
 e3b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 e3e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 e41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 e48:	89 c2                	mov    %eax,%edx
 e4a:	8b 00                	mov    (%eax),%eax
 e4c:	39 ca                	cmp    %ecx,%edx
 e4e:	73 30                	jae    e80 <free+0x50>
 e50:	39 c1                	cmp    %eax,%ecx
 e52:	72 04                	jb     e58 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 e54:	39 c2                	cmp    %eax,%edx
 e56:	72 f0                	jb     e48 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 e58:	8b 73 fc             	mov    -0x4(%ebx),%esi
 e5b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 e5e:	39 f8                	cmp    %edi,%eax
 e60:	74 30                	je     e92 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 e62:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 e65:	8b 42 04             	mov    0x4(%edx),%eax
 e68:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 e6b:	39 f1                	cmp    %esi,%ecx
 e6d:	74 3a                	je     ea9 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 e6f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 e71:	5b                   	pop    %ebx
  freep = p;
 e72:	89 15 2c 1a 00 00    	mov    %edx,0x1a2c
}
 e78:	5e                   	pop    %esi
 e79:	5f                   	pop    %edi
 e7a:	5d                   	pop    %ebp
 e7b:	c3                   	ret    
 e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 e80:	39 c2                	cmp    %eax,%edx
 e82:	72 c4                	jb     e48 <free+0x18>
 e84:	39 c1                	cmp    %eax,%ecx
 e86:	73 c0                	jae    e48 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 e88:	8b 73 fc             	mov    -0x4(%ebx),%esi
 e8b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 e8e:	39 f8                	cmp    %edi,%eax
 e90:	75 d0                	jne    e62 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 e92:	03 70 04             	add    0x4(%eax),%esi
 e95:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 e98:	8b 02                	mov    (%edx),%eax
 e9a:	8b 00                	mov    (%eax),%eax
 e9c:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 e9f:	8b 42 04             	mov    0x4(%edx),%eax
 ea2:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 ea5:	39 f1                	cmp    %esi,%ecx
 ea7:	75 c6                	jne    e6f <free+0x3f>
    p->s.size += bp->s.size;
 ea9:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 eac:	89 15 2c 1a 00 00    	mov    %edx,0x1a2c
    p->s.size += bp->s.size;
 eb2:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 eb5:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 eb8:	89 0a                	mov    %ecx,(%edx)
}
 eba:	5b                   	pop    %ebx
 ebb:	5e                   	pop    %esi
 ebc:	5f                   	pop    %edi
 ebd:	5d                   	pop    %ebp
 ebe:	c3                   	ret    
 ebf:	90                   	nop

00000ec0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 ec0:	55                   	push   %ebp
 ec1:	89 e5                	mov    %esp,%ebp
 ec3:	57                   	push   %edi
 ec4:	56                   	push   %esi
 ec5:	53                   	push   %ebx
 ec6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 ecc:	8b 3d 2c 1a 00 00    	mov    0x1a2c,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ed2:	8d 70 07             	lea    0x7(%eax),%esi
 ed5:	c1 ee 03             	shr    $0x3,%esi
 ed8:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 edb:	85 ff                	test   %edi,%edi
 edd:	0f 84 9d 00 00 00    	je     f80 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ee3:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 ee5:	8b 4a 04             	mov    0x4(%edx),%ecx
 ee8:	39 f1                	cmp    %esi,%ecx
 eea:	73 6a                	jae    f56 <malloc+0x96>
 eec:	bb 00 10 00 00       	mov    $0x1000,%ebx
 ef1:	39 de                	cmp    %ebx,%esi
 ef3:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 ef6:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 efd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 f00:	eb 17                	jmp    f19 <malloc+0x59>
 f02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 f08:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 f0a:	8b 48 04             	mov    0x4(%eax),%ecx
 f0d:	39 f1                	cmp    %esi,%ecx
 f0f:	73 4f                	jae    f60 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 f11:	8b 3d 2c 1a 00 00    	mov    0x1a2c,%edi
 f17:	89 c2                	mov    %eax,%edx
 f19:	39 d7                	cmp    %edx,%edi
 f1b:	75 eb                	jne    f08 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 f1d:	83 ec 0c             	sub    $0xc,%esp
 f20:	ff 75 e4             	push   -0x1c(%ebp)
 f23:	e8 73 fc ff ff       	call   b9b <sbrk>
  if(p == (char*)-1)
 f28:	83 c4 10             	add    $0x10,%esp
 f2b:	83 f8 ff             	cmp    $0xffffffff,%eax
 f2e:	74 1c                	je     f4c <malloc+0x8c>
  hp->s.size = nu;
 f30:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 f33:	83 ec 0c             	sub    $0xc,%esp
 f36:	83 c0 08             	add    $0x8,%eax
 f39:	50                   	push   %eax
 f3a:	e8 f1 fe ff ff       	call   e30 <free>
  return freep;
 f3f:	8b 15 2c 1a 00 00    	mov    0x1a2c,%edx
      if((p = morecore(nunits)) == 0)
 f45:	83 c4 10             	add    $0x10,%esp
 f48:	85 d2                	test   %edx,%edx
 f4a:	75 bc                	jne    f08 <malloc+0x48>
        return 0;
  }
}
 f4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 f4f:	31 c0                	xor    %eax,%eax
}
 f51:	5b                   	pop    %ebx
 f52:	5e                   	pop    %esi
 f53:	5f                   	pop    %edi
 f54:	5d                   	pop    %ebp
 f55:	c3                   	ret    
    if(p->s.size >= nunits){
 f56:	89 d0                	mov    %edx,%eax
 f58:	89 fa                	mov    %edi,%edx
 f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 f60:	39 ce                	cmp    %ecx,%esi
 f62:	74 4c                	je     fb0 <malloc+0xf0>
        p->s.size -= nunits;
 f64:	29 f1                	sub    %esi,%ecx
 f66:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 f69:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 f6c:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 f6f:	89 15 2c 1a 00 00    	mov    %edx,0x1a2c
}
 f75:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 f78:	83 c0 08             	add    $0x8,%eax
}
 f7b:	5b                   	pop    %ebx
 f7c:	5e                   	pop    %esi
 f7d:	5f                   	pop    %edi
 f7e:	5d                   	pop    %ebp
 f7f:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 f80:	c7 05 2c 1a 00 00 30 	movl   $0x1a30,0x1a2c
 f87:	1a 00 00 
    base.s.size = 0;
 f8a:	bf 30 1a 00 00       	mov    $0x1a30,%edi
    base.s.ptr = freep = prevp = &base;
 f8f:	c7 05 30 1a 00 00 30 	movl   $0x1a30,0x1a30
 f96:	1a 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 f99:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 f9b:	c7 05 34 1a 00 00 00 	movl   $0x0,0x1a34
 fa2:	00 00 00 
    if(p->s.size >= nunits){
 fa5:	e9 42 ff ff ff       	jmp    eec <malloc+0x2c>
 faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 fb0:	8b 08                	mov    (%eax),%ecx
 fb2:	89 0a                	mov    %ecx,(%edx)
 fb4:	eb b9                	jmp    f6f <malloc+0xaf>
