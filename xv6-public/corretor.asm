
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
      15:	68 9b 14 00 00       	push   $0x149b
      1a:	ff 35 4c 1b 00 00    	push   0x1b4c
      20:	e8 eb 0c 00 00       	call   d10 <printf>
  call_ok = get_date(&r);
      25:	89 1c 24             	mov    %ebx,(%esp)
      28:	e8 a3 08 00 00       	call   8d0 <get_date>
  if (call_ok == FALSE) {
      2d:	83 c4 10             	add    $0x10,%esp
      30:	85 c0                	test   %eax,%eax
      32:	75 17                	jne    4b <main+0x4b>
    printf(stdout, "[Caso 0 - ERROR] Falhou!\n");
      34:	50                   	push   %eax
      35:	50                   	push   %eax
      36:	68 b5 14 00 00       	push   $0x14b5
      3b:	ff 35 4c 1b 00 00    	push   0x1b4c
      41:	e8 ca 0c 00 00       	call   d10 <printf>
    exit();
      46:	e8 48 0b 00 00       	call   b93 <exit>
  }
  print_date(&r);
      4b:	83 ec 0c             	sub    $0xc,%esp
      4e:	53                   	push   %ebx
      4f:	e8 bc 08 00 00       	call   910 <print_date>
  printf(stdout, "[Caso 0] OK\n");
      54:	58                   	pop    %eax
      55:	5a                   	pop    %edx
      56:	68 cf 14 00 00       	push   $0x14cf
      5b:	ff 35 4c 1b 00 00    	push   0x1b4c
      61:	e8 aa 0c 00 00       	call   d10 <printf>

  get_date(&r);
      66:	89 1c 24             	mov    %ebx,(%esp)
      69:	e8 62 08 00 00       	call   8d0 <get_date>
  print_date(&r);
      6e:	89 1c 24             	mov    %ebx,(%esp)
      71:	e8 9a 08 00 00       	call   910 <print_date>
  printf(stdout, "[Caso 1] Testando o fork\n");
      76:	59                   	pop    %ecx
      77:	58                   	pop    %eax
      78:	68 dc 14 00 00       	push   $0x14dc
      7d:	ff 35 4c 1b 00 00    	push   0x1b4c
      83:	e8 88 0c 00 00       	call   d10 <printf>
  call_ok = caso1fork();
      88:	e8 a3 02 00 00       	call   330 <caso1fork>
  if (call_ok == FALSE) {
      8d:	83 c4 10             	add    $0x10,%esp
      90:	85 c0                	test   %eax,%eax
      92:	75 17                	jne    ab <main+0xab>
    printf(stdout, "[Caso 1 - ERROR] Falhou!\n");
      94:	51                   	push   %ecx
      95:	51                   	push   %ecx
      96:	68 f6 14 00 00       	push   $0x14f6
      9b:	ff 35 4c 1b 00 00    	push   0x1b4c
      a1:	e8 6a 0c 00 00       	call   d10 <printf>
    exit();
      a6:	e8 e8 0a 00 00       	call   b93 <exit>
  }
  printf(stdout, "[Caso 1] OK\n");
      ab:	50                   	push   %eax
      ac:	50                   	push   %eax
      ad:	68 10 15 00 00       	push   $0x1510
      b2:	ff 35 4c 1b 00 00    	push   0x1b4c
      b8:	e8 53 0c 00 00       	call   d10 <printf>

  get_date(&r);
      bd:	89 1c 24             	mov    %ebx,(%esp)
      c0:	e8 0b 08 00 00       	call   8d0 <get_date>
  print_date(&r);
      c5:	89 1c 24             	mov    %ebx,(%esp)
      c8:	e8 43 08 00 00       	call   910 <print_date>
  printf(stdout, "[Caso 2] Testando o forkcow\n");
      cd:	58                   	pop    %eax
      ce:	5a                   	pop    %edx
      cf:	68 1d 15 00 00       	push   $0x151d
      d4:	ff 35 4c 1b 00 00    	push   0x1b4c
      da:	e8 31 0c 00 00       	call   d10 <printf>
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
      ed:	68 54 15 00 00       	push   $0x1554
      f2:	ff 35 4c 1b 00 00    	push   0x1b4c
      f8:	e8 13 0c 00 00       	call   d10 <printf>

  get_date(&r);
      fd:	89 1c 24             	mov    %ebx,(%esp)
     100:	e8 cb 07 00 00       	call   8d0 <get_date>
  print_date(&r);
     105:	89 1c 24             	mov    %ebx,(%esp)
     108:	e8 03 08 00 00       	call   910 <print_date>
  printf(stdout, "[Caso 3] Testando se o número de páginas é igual\n");
     10d:	58                   	pop    %eax
     10e:	5a                   	pop    %edx
     10f:	68 18 13 00 00       	push   $0x1318
     114:	ff 35 4c 1b 00 00    	push   0x1b4c
     11a:	e8 f1 0b 00 00       	call   d10 <printf>
  call_ok = caso3numpgs();
     11f:	e8 8c 03 00 00       	call   4b0 <caso3numpgs>
  if (call_ok == FALSE) {
     124:	83 c4 10             	add    $0x10,%esp
     127:	85 c0                	test   %eax,%eax
     129:	75 2e                	jne    159 <main+0x159>
    printf(stdout, "[Caso 3 - ERROR] Falhou!\n");
     12b:	51                   	push   %ecx
     12c:	51                   	push   %ecx
     12d:	68 61 15 00 00       	push   $0x1561
     132:	ff 35 4c 1b 00 00    	push   0x1b4c
     138:	e8 d3 0b 00 00       	call   d10 <printf>
    exit();
     13d:	e8 51 0a 00 00       	call   b93 <exit>
    printf(stdout, "[Caso 2 - ERROR] Falhou!\n");
     142:	51                   	push   %ecx
     143:	51                   	push   %ecx
     144:	68 3a 15 00 00       	push   $0x153a
     149:	ff 35 4c 1b 00 00    	push   0x1b4c
     14f:	e8 bc 0b 00 00       	call   d10 <printf>
    exit();
     154:	e8 3a 0a 00 00       	call   b93 <exit>
  }
  printf(stdout, "[Caso 3] OK\n");
     159:	50                   	push   %eax
     15a:	50                   	push   %eax
     15b:	68 7b 15 00 00       	push   $0x157b
     160:	ff 35 4c 1b 00 00    	push   0x1b4c
     166:	e8 a5 0b 00 00       	call   d10 <printf>

  get_date(&r);
     16b:	89 1c 24             	mov    %ebx,(%esp)
     16e:	e8 5d 07 00 00       	call   8d0 <get_date>
  print_date(&r);
     173:	89 1c 24             	mov    %ebx,(%esp)
     176:	e8 95 07 00 00       	call   910 <print_date>
  printf(stdout, "[Caso 4] Testando se o endereço de uma constante é =\n");
     17b:	58                   	pop    %eax
     17c:	5a                   	pop    %edx
     17d:	68 50 13 00 00       	push   $0x1350
     182:	ff 35 4c 1b 00 00    	push   0x1b4c
     188:	e8 83 0b 00 00       	call   d10 <printf>
  call_ok = caso4mesmoaddr();
     18d:	e8 0e 04 00 00       	call   5a0 <caso4mesmoaddr>
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
     19b:	68 a2 15 00 00       	push   $0x15a2
     1a0:	ff 35 4c 1b 00 00    	push   0x1b4c
     1a6:	e8 65 0b 00 00       	call   d10 <printf>

  get_date(&r);
     1ab:	89 1c 24             	mov    %ebx,(%esp)
     1ae:	e8 1d 07 00 00       	call   8d0 <get_date>
  print_date(&r);
     1b3:	89 1c 24             	mov    %ebx,(%esp)
     1b6:	e8 55 07 00 00       	call   910 <print_date>
  printf(stdout, "[Caso 5] Testando se o endereço de uma global é =\n");
     1bb:	58                   	pop    %eax
     1bc:	5a                   	pop    %edx
     1bd:	68 88 13 00 00       	push   $0x1388
     1c2:	ff 35 4c 1b 00 00    	push   0x1b4c
     1c8:	e8 43 0b 00 00       	call   d10 <printf>
  call_ok = caso5mesmoaddr();
     1cd:	e8 de 04 00 00       	call   6b0 <caso5mesmoaddr>
  if (call_ok == FALSE) {
     1d2:	83 c4 10             	add    $0x10,%esp
     1d5:	85 c0                	test   %eax,%eax
     1d7:	75 2e                	jne    207 <main+0x207>
    printf(stdout, "[Caso 5 - ERROR] Falhou!\n");
     1d9:	51                   	push   %ecx
     1da:	51                   	push   %ecx
     1db:	68 af 15 00 00       	push   $0x15af
     1e0:	ff 35 4c 1b 00 00    	push   0x1b4c
     1e6:	e8 25 0b 00 00       	call   d10 <printf>
    exit();
     1eb:	e8 a3 09 00 00       	call   b93 <exit>
    printf(stdout, "[Caso 4 - ERROR] Falhou!\n");
     1f0:	51                   	push   %ecx
     1f1:	51                   	push   %ecx
     1f2:	68 88 15 00 00       	push   $0x1588
     1f7:	ff 35 4c 1b 00 00    	push   0x1b4c
     1fd:	e8 0e 0b 00 00       	call   d10 <printf>
    exit();
     202:	e8 8c 09 00 00       	call   b93 <exit>
  }
  printf(stdout, "[Caso 5] OK\n");
     207:	50                   	push   %eax
     208:	50                   	push   %eax
     209:	68 c9 15 00 00       	push   $0x15c9
     20e:	ff 35 4c 1b 00 00    	push   0x1b4c
     214:	e8 f7 0a 00 00       	call   d10 <printf>

  get_date(&r);
     219:	89 1c 24             	mov    %ebx,(%esp)
     21c:	e8 af 06 00 00       	call   8d0 <get_date>
  print_date(&r);
     221:	89 1c 24             	mov    %ebx,(%esp)
     224:	e8 e7 06 00 00       	call   910 <print_date>
  printf(stdout, "[Caso 6] Testando o COW\n");
     229:	58                   	pop    %eax
     22a:	5a                   	pop    %edx
     22b:	68 d6 15 00 00       	push   $0x15d6
     230:	ff 35 4c 1b 00 00    	push   0x1b4c
     236:	e8 d5 0a 00 00       	call   d10 <printf>
  call_ok = caso6cow();
     23b:	e8 80 05 00 00       	call   7c0 <caso6cow>
  if (call_ok == FALSE) {
     240:	83 c4 10             	add    $0x10,%esp
     243:	85 c0                	test   %eax,%eax
     245:	75 17                	jne    25e <main+0x25e>
    printf(stdout, "[Caso 6 - ERROR] Falhou!\n");
     247:	50                   	push   %eax
     248:	50                   	push   %eax
     249:	68 ef 15 00 00       	push   $0x15ef
     24e:	ff 35 4c 1b 00 00    	push   0x1b4c
     254:	e8 b7 0a 00 00       	call   d10 <printf>
    exit();
     259:	e8 35 09 00 00       	call   b93 <exit>
  }
  printf(stdout, "[Caso 6] OK\n");
     25e:	50                   	push   %eax
     25f:	50                   	push   %eax
     260:	68 09 16 00 00       	push   $0x1609
     265:	ff 35 4c 1b 00 00    	push   0x1b4c
     26b:	e8 a0 0a 00 00       	call   d10 <printf>
  printf(stdout, "\n");
     270:	5a                   	pop    %edx
     271:	59                   	pop    %ecx
     272:	68 6f 16 00 00       	push   $0x166f
     277:	ff 35 4c 1b 00 00    	push   0x1b4c
     27d:	e8 8e 0a 00 00       	call   d10 <printf>
  printf(stdout, "         (__)        \n");
     282:	5b                   	pop    %ebx
     283:	58                   	pop    %eax
     284:	68 16 16 00 00       	push   $0x1616
     289:	ff 35 4c 1b 00 00    	push   0x1b4c
     28f:	e8 7c 0a 00 00       	call   d10 <printf>
  printf(stdout, "         (oo)        \n");
     294:	58                   	pop    %eax
     295:	5a                   	pop    %edx
     296:	68 2d 16 00 00       	push   $0x162d
     29b:	ff 35 4c 1b 00 00    	push   0x1b4c
     2a1:	e8 6a 0a 00 00       	call   d10 <printf>
  printf(stdout, "   /------\\/        \n");
     2a6:	59                   	pop    %ecx
     2a7:	5b                   	pop    %ebx
     2a8:	68 44 16 00 00       	push   $0x1644
     2ad:	ff 35 4c 1b 00 00    	push   0x1b4c
     2b3:	e8 58 0a 00 00       	call   d10 <printf>
  printf(stdout, "  / |    ||          \n");
     2b8:	58                   	pop    %eax
     2b9:	5a                   	pop    %edx
     2ba:	68 5a 16 00 00       	push   $0x165a
     2bf:	ff 35 4c 1b 00 00    	push   0x1b4c
     2c5:	e8 46 0a 00 00       	call   d10 <printf>
  printf(stdout, " *  /\\---/\\        \n");
     2ca:	59                   	pop    %ecx
     2cb:	5b                   	pop    %ebx
     2cc:	68 71 16 00 00       	push   $0x1671
     2d1:	ff 35 4c 1b 00 00    	push   0x1b4c
     2d7:	e8 34 0a 00 00       	call   d10 <printf>
  printf(stdout, "    ~~   ~~          \n");
     2dc:	58                   	pop    %eax
     2dd:	5a                   	pop    %edx
     2de:	68 86 16 00 00       	push   $0x1686
     2e3:	ff 35 4c 1b 00 00    	push   0x1b4c
     2e9:	e8 22 0a 00 00       	call   d10 <printf>
  printf(stdout, "....\"Congratulations! You have mooed!\"...\n");
     2ee:	59                   	pop    %ecx
     2ef:	5b                   	pop    %ebx
     2f0:	68 c0 13 00 00       	push   $0x13c0
     2f5:	ff 35 4c 1b 00 00    	push   0x1b4c
     2fb:	e8 10 0a 00 00       	call   d10 <printf>
  printf(stdout, "\n");
     300:	58                   	pop    %eax
     301:	5a                   	pop    %edx
     302:	68 6f 16 00 00       	push   $0x166f
     307:	ff 35 4c 1b 00 00    	push   0x1b4c
     30d:	e8 fe 09 00 00       	call   d10 <printf>
  printf(stdout, "[0xDCC605 - COW] ALL OK!!!\n");
     312:	59                   	pop    %ecx
     313:	5b                   	pop    %ebx
     314:	68 9d 16 00 00       	push   $0x169d
     319:	ff 35 4c 1b 00 00    	push   0x1b4c
     31f:	e8 ec 09 00 00       	call   d10 <printf>
  exit();
     324:	e8 6a 08 00 00       	call   b93 <exit>
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
     33b:	68 38 10 00 00       	push   $0x1038
     340:	ff 35 4c 1b 00 00    	push   0x1b4c
     346:	e8 c5 09 00 00       	call   d10 <printf>
     34b:	83 c4 10             	add    $0x10,%esp
     34e:	66 90                	xchg   %ax,%ax
    pid = fork();
     350:	e8 36 08 00 00       	call   b8b <fork>
    if(pid < 0) {
     355:	85 c0                	test   %eax,%eax
     357:	78 27                	js     380 <caso1fork+0x50>
    if(pid == 0)
     359:	74 4c                	je     3a7 <caso1fork+0x77>
      if (wait() < 0) return FALSE;
     35b:	e8 3b 08 00 00       	call   b9b <wait>
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
     384:	68 60 10 00 00       	push   $0x1060
     389:	ff 35 4c 1b 00 00    	push   0x1b4c
     38f:	e8 7c 09 00 00       	call   d10 <printf>
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
     3a7:	e8 e7 07 00 00       	call   b93 <exit>
     3ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000003b0 <caso2forkcow>:
int caso2forkcow(void) {
     3b0:	55                   	push   %ebp
     3b1:	89 e5                	mov    %esp,%ebp
     3b3:	56                   	push   %esi
  for(n = 0; n < N; n++) {
     3b4:	31 f6                	xor    %esi,%esi
int caso2forkcow(void) {
     3b6:	53                   	push   %ebx
  printf(stdout, "[--Caso 2.1] Testando %d chamadas forkcow\n", N);
     3b7:	83 ec 04             	sub    $0x4,%esp
     3ba:	6a 0a                	push   $0xa
     3bc:	68 88 10 00 00       	push   $0x1088
     3c1:	ff 35 4c 1b 00 00    	push   0x1b4c
     3c7:	e8 44 09 00 00       	call   d10 <printf>
     3cc:	83 c4 10             	add    $0x10,%esp
     3cf:	90                   	nop
    printf(stdout, "Calling forkcow #%d\n", n);
     3d0:	83 ec 04             	sub    $0x4,%esp
     3d3:	56                   	push   %esi
     3d4:	68 eb 13 00 00       	push   $0x13eb
     3d9:	ff 35 4c 1b 00 00    	push   0x1b4c
     3df:	e8 2c 09 00 00       	call   d10 <printf>
    pid = forkcow();
     3e4:	e8 62 08 00 00       	call   c4b <forkcow>
    if (pid < 0) {
     3e9:	83 c4 10             	add    $0x10,%esp
    pid = forkcow();
     3ec:	89 c3                	mov    %eax,%ebx
    if (pid < 0) {
     3ee:	85 c0                	test   %eax,%eax
     3f0:	78 56                	js     448 <caso2forkcow+0x98>
    if (pid == 0) {
     3f2:	0f 84 98 00 00 00    	je     490 <caso2forkcow+0xe0>
      printf(stdout, "Waiting for pid %d\n", pid);
     3f8:	83 ec 04             	sub    $0x4,%esp
     3fb:	50                   	push   %eax
     3fc:	68 00 14 00 00       	push   $0x1400
     401:	ff 35 4c 1b 00 00    	push   0x1b4c
     407:	e8 04 09 00 00       	call   d10 <printf>
      if (wait() < 0) {
     40c:	e8 8a 07 00 00       	call   b9b <wait>
     411:	83 c4 10             	add    $0x10,%esp
     414:	85 c0                	test   %eax,%eax
     416:	78 58                	js     470 <caso2forkcow+0xc0>
      printf(stdout, "Finished waiting for pid %d\n", pid);
     418:	83 ec 04             	sub    $0x4,%esp
  for(n = 0; n < N; n++) {
     41b:	83 c6 01             	add    $0x1,%esi
      printf(stdout, "Finished waiting for pid %d\n", pid);
     41e:	53                   	push   %ebx
     41f:	68 14 14 00 00       	push   $0x1414
     424:	ff 35 4c 1b 00 00    	push   0x1b4c
     42a:	e8 e1 08 00 00       	call   d10 <printf>
  for(n = 0; n < N; n++) {
     42f:	83 c4 10             	add    $0x10,%esp
     432:	83 fe 0a             	cmp    $0xa,%esi
     435:	75 99                	jne    3d0 <caso2forkcow+0x20>
}
     437:	8d 65 f8             	lea    -0x8(%ebp),%esp
  return TRUE;
     43a:	b8 01 00 00 00       	mov    $0x1,%eax
}
     43f:	5b                   	pop    %ebx
     440:	5e                   	pop    %esi
     441:	5d                   	pop    %ebp
     442:	c3                   	ret    
     443:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     447:	90                   	nop
      printf(stdout, "[--Caso 2.1 - ERROR] Fork %d falhou!\n", n);
     448:	83 ec 04             	sub    $0x4,%esp
     44b:	56                   	push   %esi
     44c:	68 b4 10 00 00       	push   $0x10b4
     451:	ff 35 4c 1b 00 00    	push   0x1b4c
     457:	e8 b4 08 00 00       	call   d10 <printf>
      return FALSE;
     45c:	83 c4 10             	add    $0x10,%esp
}
     45f:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return FALSE;
     462:	31 c0                	xor    %eax,%eax
}
     464:	5b                   	pop    %ebx
     465:	5e                   	pop    %esi
     466:	5d                   	pop    %ebp
     467:	c3                   	ret    
     468:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     46f:	90                   	nop
        printf(stdout, "[--Caso 2.1 - ERROR] Wait for pid %d failed!\n", pid);
     470:	83 ec 04             	sub    $0x4,%esp
     473:	53                   	push   %ebx
     474:	68 fc 10 00 00       	push   $0x10fc
     479:	ff 35 4c 1b 00 00    	push   0x1b4c
     47f:	e8 8c 08 00 00       	call   d10 <printf>
        return FALSE;
     484:	83 c4 10             	add    $0x10,%esp
}
     487:	8d 65 f8             	lea    -0x8(%ebp),%esp
        return FALSE;
     48a:	31 c0                	xor    %eax,%eax
}
     48c:	5b                   	pop    %ebx
     48d:	5e                   	pop    %esi
     48e:	5d                   	pop    %ebp
     48f:	c3                   	ret    
      printf(stdout, "Closing the child with pid %d\n", getpid());
     490:	e8 7e 07 00 00       	call   c13 <getpid>
     495:	83 ec 04             	sub    $0x4,%esp
     498:	50                   	push   %eax
     499:	68 dc 10 00 00       	push   $0x10dc
     49e:	ff 35 4c 1b 00 00    	push   0x1b4c
     4a4:	e8 67 08 00 00       	call   d10 <printf>
      exit();  // Close child
     4a9:	e8 e5 06 00 00       	call   b93 <exit>
     4ae:	66 90                	xchg   %ax,%ax

000004b0 <caso3numpgs>:
int caso3numpgs(void) {
     4b0:	55                   	push   %ebp
     4b1:	89 e5                	mov    %esp,%ebp
     4b3:	56                   	push   %esi
     4b4:	53                   	push   %ebx
  pipe(fd);
     4b5:	8d 45 dc             	lea    -0x24(%ebp),%eax
int caso3numpgs(void) {
     4b8:	83 ec 2c             	sub    $0x2c,%esp
  pipe(fd);
     4bb:	50                   	push   %eax
     4bc:	e8 e2 06 00 00       	call   ba3 <pipe>
  int np = num_pages();
     4c1:	e8 7d 07 00 00       	call   c43 <num_pages>
     4c6:	89 c3                	mov    %eax,%ebx
  int pid = forkcow();
     4c8:	e8 7e 07 00 00       	call   c4b <forkcow>
  if (pid == 0) { // child manda número de páginas de da exit
     4cd:	83 c4 10             	add    $0x10,%esp
     4d0:	85 c0                	test   %eax,%eax
     4d2:	74 72                	je     546 <caso3numpgs+0x96>
    close(fd[1]);
     4d4:	83 ec 0c             	sub    $0xc,%esp
     4d7:	ff 75 e0             	push   -0x20(%ebp)
    read(fd[0], answer, 20);
     4da:	8d 75 e4             	lea    -0x1c(%ebp),%esi
    close(fd[1]);
     4dd:	e8 d9 06 00 00       	call   bbb <close>
    wait();
     4e2:	e8 b4 06 00 00       	call   b9b <wait>
    printf(stdout, "[--Caso 3.3] Parent lendo num_pages\n");
     4e7:	58                   	pop    %eax
     4e8:	5a                   	pop    %edx
     4e9:	68 74 11 00 00       	push   $0x1174
     4ee:	ff 35 4c 1b 00 00    	push   0x1b4c
     4f4:	e8 17 08 00 00       	call   d10 <printf>
    read(fd[0], answer, 20);
     4f9:	83 c4 0c             	add    $0xc,%esp
     4fc:	6a 14                	push   $0x14
     4fe:	56                   	push   %esi
     4ff:	ff 75 dc             	push   -0x24(%ebp)
     502:	e8 a4 06 00 00       	call   bab <read>
    printf(stdout, "[--Caso 3.4] Parent leu %d == %d\n", np, atoi(answer));
     507:	89 34 24             	mov    %esi,(%esp)
     50a:	e8 11 06 00 00       	call   b20 <atoi>
     50f:	50                   	push   %eax
     510:	53                   	push   %ebx
     511:	68 9c 11 00 00       	push   $0x119c
     516:	ff 35 4c 1b 00 00    	push   0x1b4c
     51c:	e8 ef 07 00 00       	call   d10 <printf>
    close(fd[0]);
     521:	83 c4 14             	add    $0x14,%esp
     524:	ff 75 dc             	push   -0x24(%ebp)
     527:	e8 8f 06 00 00       	call   bbb <close>
    return atoi(answer) == np;
     52c:	89 34 24             	mov    %esi,(%esp)
     52f:	e8 ec 05 00 00       	call   b20 <atoi>
     534:	83 c4 10             	add    $0x10,%esp
     537:	39 d8                	cmp    %ebx,%eax
     539:	0f 94 c0             	sete   %al
}
     53c:	8d 65 f8             	lea    -0x8(%ebp),%esp
     53f:	5b                   	pop    %ebx
    return atoi(answer) == np;
     540:	0f b6 c0             	movzbl %al,%eax
}
     543:	5e                   	pop    %esi
     544:	5d                   	pop    %ebp
     545:	c3                   	ret    
    printf(stdout, "[--Caso 3.1] Child write num_pages %d\n", num_pages());
     546:	e8 f8 06 00 00       	call   c43 <num_pages>
     54b:	51                   	push   %ecx
     54c:	50                   	push   %eax
     54d:	68 2c 11 00 00       	push   $0x112c
     552:	ff 35 4c 1b 00 00    	push   0x1b4c
     558:	e8 b3 07 00 00       	call   d10 <printf>
    close(fd[0]);
     55d:	5b                   	pop    %ebx
     55e:	ff 75 dc             	push   -0x24(%ebp)
     561:	e8 55 06 00 00       	call   bbb <close>
    printf(fd[1], "%d\0", num_pages());
     566:	e8 d8 06 00 00       	call   c43 <num_pages>
     56b:	83 c4 0c             	add    $0xc,%esp
     56e:	50                   	push   %eax
     56f:	68 bc 16 00 00       	push   $0x16bc
     574:	ff 75 e0             	push   -0x20(%ebp)
     577:	e8 94 07 00 00       	call   d10 <printf>
    printf(stdout, "[--Caso 3.2] Child indo embora\n");
     57c:	5e                   	pop    %esi
     57d:	58                   	pop    %eax
     57e:	68 54 11 00 00       	push   $0x1154
     583:	ff 35 4c 1b 00 00    	push   0x1b4c
     589:	e8 82 07 00 00       	call   d10 <printf>
    close(fd[1]);
     58e:	58                   	pop    %eax
     58f:	ff 75 e0             	push   -0x20(%ebp)
     592:	e8 24 06 00 00       	call   bbb <close>
    exit();
     597:	e8 f7 05 00 00       	call   b93 <exit>
     59c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000005a0 <caso4mesmoaddr>:
int caso4mesmoaddr(void) {
     5a0:	55                   	push   %ebp
     5a1:	89 e5                	mov    %esp,%ebp
     5a3:	56                   	push   %esi
     5a4:	53                   	push   %ebx
  pipe(fd);
     5a5:	8d 45 dc             	lea    -0x24(%ebp),%eax
int caso4mesmoaddr(void) {
     5a8:	83 ec 2c             	sub    $0x2c,%esp
  pipe(fd);
     5ab:	50                   	push   %eax
     5ac:	e8 f2 05 00 00       	call   ba3 <pipe>
  int pid = forkcow();
     5b1:	e8 95 06 00 00       	call   c4b <forkcow>
  if (pid == 0) { // child manda addr de GLOBAL1_RO
     5b6:	83 c4 10             	add    $0x10,%esp
     5b9:	85 c0                	test   %eax,%eax
     5bb:	0f 84 84 00 00 00    	je     645 <caso4mesmoaddr+0xa5>
    int addr = (int)virt2real((char*)&GLOBAL1_RO);
     5c1:	83 ec 0c             	sub    $0xc,%esp
    read(fd[0], answer, 20);
     5c4:	8d 75 e4             	lea    -0x1c(%ebp),%esi
    int addr = (int)virt2real((char*)&GLOBAL1_RO);
     5c7:	68 c0 16 00 00       	push   $0x16c0
     5cc:	e8 6a 06 00 00       	call   c3b <virt2real>
    if (addr < 0) addr = -addr; // atoi falha quando <0, nao sei pq
     5d1:	89 c3                	mov    %eax,%ebx
     5d3:	f7 db                	neg    %ebx
     5d5:	0f 48 d8             	cmovs  %eax,%ebx
    close(fd[1]);
     5d8:	58                   	pop    %eax
     5d9:	ff 75 e0             	push   -0x20(%ebp)
     5dc:	e8 da 05 00 00       	call   bbb <close>
    wait();
     5e1:	e8 b5 05 00 00       	call   b9b <wait>
    printf(stdout, "[--Caso 4.3] Parent lendo addr\n");
     5e6:	5a                   	pop    %edx
     5e7:	59                   	pop    %ecx
     5e8:	68 e0 11 00 00       	push   $0x11e0
     5ed:	ff 35 4c 1b 00 00    	push   0x1b4c
     5f3:	e8 18 07 00 00       	call   d10 <printf>
    read(fd[0], answer, 20);
     5f8:	83 c4 0c             	add    $0xc,%esp
     5fb:	6a 14                	push   $0x14
     5fd:	56                   	push   %esi
     5fe:	ff 75 dc             	push   -0x24(%ebp)
     601:	e8 a5 05 00 00       	call   bab <read>
    printf(stdout, "[--Caso 4.4] Parent leu %d == %d\n",
     606:	89 34 24             	mov    %esi,(%esp)
     609:	e8 12 05 00 00       	call   b20 <atoi>
     60e:	50                   	push   %eax
     60f:	53                   	push   %ebx
     610:	68 00 12 00 00       	push   $0x1200
     615:	ff 35 4c 1b 00 00    	push   0x1b4c
     61b:	e8 f0 06 00 00       	call   d10 <printf>
    close(fd[0]);
     620:	83 c4 14             	add    $0x14,%esp
     623:	ff 75 dc             	push   -0x24(%ebp)
     626:	e8 90 05 00 00       	call   bbb <close>
    return addr == atoi(answer);
     62b:	89 34 24             	mov    %esi,(%esp)
     62e:	e8 ed 04 00 00       	call   b20 <atoi>
     633:	83 c4 10             	add    $0x10,%esp
     636:	39 d8                	cmp    %ebx,%eax
     638:	0f 94 c0             	sete   %al
}
     63b:	8d 65 f8             	lea    -0x8(%ebp),%esp
     63e:	5b                   	pop    %ebx
    return addr == atoi(answer);
     63f:	0f b6 c0             	movzbl %al,%eax
}
     642:	5e                   	pop    %esi
     643:	5d                   	pop    %ebp
     644:	c3                   	ret    
    int addr = (int)virt2real((char*)&GLOBAL1_RO);
     645:	83 ec 0c             	sub    $0xc,%esp
     648:	68 c0 16 00 00       	push   $0x16c0
     64d:	e8 e9 05 00 00       	call   c3b <virt2real>
    if (addr < 0) addr = -addr; // atoi falha quando <0, nao sei pq
     652:	83 c4 0c             	add    $0xc,%esp
     655:	89 c3                	mov    %eax,%ebx
     657:	f7 db                	neg    %ebx
     659:	0f 48 d8             	cmovs  %eax,%ebx
    printf(stdout, "[--Caso 4.1] Child write %d\n", addr);
     65c:	53                   	push   %ebx
     65d:	68 31 14 00 00       	push   $0x1431
     662:	ff 35 4c 1b 00 00    	push   0x1b4c
     668:	e8 a3 06 00 00       	call   d10 <printf>
    close(fd[0]);
     66d:	5e                   	pop    %esi
     66e:	ff 75 dc             	push   -0x24(%ebp)
     671:	e8 45 05 00 00       	call   bbb <close>
    printf(fd[1], "%d\0", addr);
     676:	83 c4 0c             	add    $0xc,%esp
     679:	53                   	push   %ebx
     67a:	68 bc 16 00 00       	push   $0x16bc
     67f:	ff 75 e0             	push   -0x20(%ebp)
     682:	e8 89 06 00 00       	call   d10 <printf>
    printf(stdout, "[--Caso 4.2] Child indo embora\n");
     687:	58                   	pop    %eax
     688:	5a                   	pop    %edx
     689:	68 c0 11 00 00       	push   $0x11c0
     68e:	ff 35 4c 1b 00 00    	push   0x1b4c
     694:	e8 77 06 00 00       	call   d10 <printf>
    close(fd[1]);
     699:	59                   	pop    %ecx
     69a:	ff 75 e0             	push   -0x20(%ebp)
     69d:	e8 19 05 00 00       	call   bbb <close>
    exit();
     6a2:	e8 ec 04 00 00       	call   b93 <exit>
     6a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     6ae:	66 90                	xchg   %ax,%ax

000006b0 <caso5mesmoaddr>:
int caso5mesmoaddr(void) {
     6b0:	55                   	push   %ebp
     6b1:	89 e5                	mov    %esp,%ebp
     6b3:	56                   	push   %esi
     6b4:	53                   	push   %ebx
  pipe(fd);
     6b5:	8d 45 dc             	lea    -0x24(%ebp),%eax
int caso5mesmoaddr(void) {
     6b8:	83 ec 2c             	sub    $0x2c,%esp
  pipe(fd);
     6bb:	50                   	push   %eax
     6bc:	e8 e2 04 00 00       	call   ba3 <pipe>
  int pid = forkcow();
     6c1:	e8 85 05 00 00       	call   c4b <forkcow>
  if (pid == 0) { // child manda addr de GLOBAL1_RO
     6c6:	83 c4 10             	add    $0x10,%esp
     6c9:	85 c0                	test   %eax,%eax
     6cb:	0f 84 84 00 00 00    	je     755 <caso5mesmoaddr+0xa5>
    int addr = (int)virt2real((char*)&GLOBAL2_RW);
     6d1:	83 ec 0c             	sub    $0xc,%esp
    read(fd[0], answer, 20);
     6d4:	8d 75 e4             	lea    -0x1c(%ebp),%esi
    int addr = (int)virt2real((char*)&GLOBAL2_RW);
     6d7:	68 44 1b 00 00       	push   $0x1b44
     6dc:	e8 5a 05 00 00       	call   c3b <virt2real>
    if (addr < 0) addr = -addr; // atoi falha quando <0, nao sei pq
     6e1:	89 c3                	mov    %eax,%ebx
     6e3:	f7 db                	neg    %ebx
     6e5:	0f 48 d8             	cmovs  %eax,%ebx
    close(fd[1]);
     6e8:	58                   	pop    %eax
     6e9:	ff 75 e0             	push   -0x20(%ebp)
     6ec:	e8 ca 04 00 00       	call   bbb <close>
    wait();
     6f1:	e8 a5 04 00 00       	call   b9b <wait>
    printf(stdout, "[--Caso 5.3] Parent lendo addr\n");
     6f6:	5a                   	pop    %edx
     6f7:	59                   	pop    %ecx
     6f8:	68 44 12 00 00       	push   $0x1244
     6fd:	ff 35 4c 1b 00 00    	push   0x1b4c
     703:	e8 08 06 00 00       	call   d10 <printf>
    read(fd[0], answer, 20);
     708:	83 c4 0c             	add    $0xc,%esp
     70b:	6a 14                	push   $0x14
     70d:	56                   	push   %esi
     70e:	ff 75 dc             	push   -0x24(%ebp)
     711:	e8 95 04 00 00       	call   bab <read>
    printf(stdout, "[--Caso 5.4] Parent leu %d == %d\n",
     716:	89 34 24             	mov    %esi,(%esp)
     719:	e8 02 04 00 00       	call   b20 <atoi>
     71e:	50                   	push   %eax
     71f:	53                   	push   %ebx
     720:	68 64 12 00 00       	push   $0x1264
     725:	ff 35 4c 1b 00 00    	push   0x1b4c
     72b:	e8 e0 05 00 00       	call   d10 <printf>
    close(fd[0]);
     730:	83 c4 14             	add    $0x14,%esp
     733:	ff 75 dc             	push   -0x24(%ebp)
     736:	e8 80 04 00 00       	call   bbb <close>
    return addr == atoi(answer);
     73b:	89 34 24             	mov    %esi,(%esp)
     73e:	e8 dd 03 00 00       	call   b20 <atoi>
     743:	83 c4 10             	add    $0x10,%esp
     746:	39 d8                	cmp    %ebx,%eax
     748:	0f 94 c0             	sete   %al
}
     74b:	8d 65 f8             	lea    -0x8(%ebp),%esp
     74e:	5b                   	pop    %ebx
    return addr == atoi(answer);
     74f:	0f b6 c0             	movzbl %al,%eax
}
     752:	5e                   	pop    %esi
     753:	5d                   	pop    %ebp
     754:	c3                   	ret    
    int addr = (int)virt2real((char*)&GLOBAL2_RW);
     755:	83 ec 0c             	sub    $0xc,%esp
     758:	68 44 1b 00 00       	push   $0x1b44
     75d:	e8 d9 04 00 00       	call   c3b <virt2real>
    if (addr < 0) addr = -addr; // atoi falha quando <0, nao sei pq
     762:	83 c4 0c             	add    $0xc,%esp
     765:	89 c3                	mov    %eax,%ebx
     767:	f7 db                	neg    %ebx
     769:	0f 48 d8             	cmovs  %eax,%ebx
    printf(stdout, "[--Caso 5.1] Child write %d\n", addr);
     76c:	53                   	push   %ebx
     76d:	68 4e 14 00 00       	push   $0x144e
     772:	ff 35 4c 1b 00 00    	push   0x1b4c
     778:	e8 93 05 00 00       	call   d10 <printf>
    close(fd[0]);
     77d:	5e                   	pop    %esi
     77e:	ff 75 dc             	push   -0x24(%ebp)
     781:	e8 35 04 00 00       	call   bbb <close>
    printf(fd[1], "%d\0", addr);
     786:	83 c4 0c             	add    $0xc,%esp
     789:	53                   	push   %ebx
     78a:	68 bc 16 00 00       	push   $0x16bc
     78f:	ff 75 e0             	push   -0x20(%ebp)
     792:	e8 79 05 00 00       	call   d10 <printf>
    printf(stdout, "[--Caso 5.2] Child indo embora\n");
     797:	58                   	pop    %eax
     798:	5a                   	pop    %edx
     799:	68 24 12 00 00       	push   $0x1224
     79e:	ff 35 4c 1b 00 00    	push   0x1b4c
     7a4:	e8 67 05 00 00       	call   d10 <printf>
    close(fd[1]);
     7a9:	59                   	pop    %ecx
     7aa:	ff 75 e0             	push   -0x20(%ebp)
     7ad:	e8 09 04 00 00       	call   bbb <close>
    exit();
     7b2:	e8 dc 03 00 00       	call   b93 <exit>
     7b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     7be:	66 90                	xchg   %ax,%ax

000007c0 <caso6cow>:
int caso6cow(void) {
     7c0:	55                   	push   %ebp
     7c1:	89 e5                	mov    %esp,%ebp
     7c3:	56                   	push   %esi
     7c4:	53                   	push   %ebx
  pipe(fd);
     7c5:	8d 45 dc             	lea    -0x24(%ebp),%eax
int caso6cow(void) {
     7c8:	83 ec 2c             	sub    $0x2c,%esp
  pipe(fd);
     7cb:	50                   	push   %eax
     7cc:	e8 d2 03 00 00       	call   ba3 <pipe>
  int pid = forkcow();
     7d1:	e8 75 04 00 00       	call   c4b <forkcow>
  if (pid == 0) { // child manda addr de GLOBAL2_RW
     7d6:	83 c4 10             	add    $0x10,%esp
     7d9:	85 c0                	test   %eax,%eax
     7db:	0f 84 84 00 00 00    	je     865 <caso6cow+0xa5>
    int addr = (int)virt2real((char*)&GLOBAL2_RW);
     7e1:	83 ec 0c             	sub    $0xc,%esp
    read(fd[0], answer, 20);
     7e4:	8d 75 e4             	lea    -0x1c(%ebp),%esi
    int addr = (int)virt2real((char*)&GLOBAL2_RW);
     7e7:	68 44 1b 00 00       	push   $0x1b44
     7ec:	e8 4a 04 00 00       	call   c3b <virt2real>
    if (addr < 0) addr = -addr; // atoi falha quando <0, nao sei pq
     7f1:	89 c3                	mov    %eax,%ebx
     7f3:	f7 db                	neg    %ebx
     7f5:	0f 48 d8             	cmovs  %eax,%ebx
    close(fd[1]);
     7f8:	58                   	pop    %eax
     7f9:	ff 75 e0             	push   -0x20(%ebp)
     7fc:	e8 ba 03 00 00       	call   bbb <close>
    wait();
     801:	e8 95 03 00 00       	call   b9b <wait>
    printf(stdout, "[--Caso 6.3] Parent lendo addr\n");
     806:	5a                   	pop    %edx
     807:	59                   	pop    %ecx
     808:	68 a8 12 00 00       	push   $0x12a8
     80d:	ff 35 4c 1b 00 00    	push   0x1b4c
     813:	e8 f8 04 00 00       	call   d10 <printf>
    read(fd[0], answer, 20);
     818:	83 c4 0c             	add    $0xc,%esp
     81b:	6a 14                	push   $0x14
     81d:	56                   	push   %esi
     81e:	ff 75 dc             	push   -0x24(%ebp)
     821:	e8 85 03 00 00       	call   bab <read>
    printf(stdout, "[--Caso 6.4] Parent leu %d != %d\n",
     826:	89 34 24             	mov    %esi,(%esp)
     829:	e8 f2 02 00 00       	call   b20 <atoi>
     82e:	50                   	push   %eax
     82f:	53                   	push   %ebx
     830:	68 c8 12 00 00       	push   $0x12c8
     835:	ff 35 4c 1b 00 00    	push   0x1b4c
     83b:	e8 d0 04 00 00       	call   d10 <printf>
    close(fd[0]);
     840:	83 c4 14             	add    $0x14,%esp
     843:	ff 75 dc             	push   -0x24(%ebp)
     846:	e8 70 03 00 00       	call   bbb <close>
    return addr != atoi(answer);
     84b:	89 34 24             	mov    %esi,(%esp)
     84e:	e8 cd 02 00 00       	call   b20 <atoi>
     853:	83 c4 10             	add    $0x10,%esp
     856:	39 d8                	cmp    %ebx,%eax
     858:	0f 95 c0             	setne  %al
}
     85b:	8d 65 f8             	lea    -0x8(%ebp),%esp
     85e:	5b                   	pop    %ebx
    return addr != atoi(answer);
     85f:	0f b6 c0             	movzbl %al,%eax
}
     862:	5e                   	pop    %esi
     863:	5d                   	pop    %ebp
     864:	c3                   	ret    
    int addr = (int)virt2real((char*)&GLOBAL2_RW);
     865:	83 ec 0c             	sub    $0xc,%esp
    GLOBAL2_RW--;
     868:	83 2d 44 1b 00 00 01 	subl   $0x1,0x1b44
    int addr = (int)virt2real((char*)&GLOBAL2_RW);
     86f:	68 44 1b 00 00       	push   $0x1b44
     874:	e8 c2 03 00 00       	call   c3b <virt2real>
    if (addr < 0) addr = -addr; // atoi falha quando <0, nao sei pq
     879:	83 c4 0c             	add    $0xc,%esp
     87c:	89 c3                	mov    %eax,%ebx
     87e:	f7 db                	neg    %ebx
     880:	0f 48 d8             	cmovs  %eax,%ebx
    printf(stdout, "[--Caso 6.1] Child write %d\n", addr);
     883:	53                   	push   %ebx
     884:	68 6b 14 00 00       	push   $0x146b
     889:	ff 35 4c 1b 00 00    	push   0x1b4c
     88f:	e8 7c 04 00 00       	call   d10 <printf>
    close(fd[0]);
     894:	5e                   	pop    %esi
     895:	ff 75 dc             	push   -0x24(%ebp)
     898:	e8 1e 03 00 00       	call   bbb <close>
    printf(fd[1], "%d\0", addr);
     89d:	83 c4 0c             	add    $0xc,%esp
     8a0:	53                   	push   %ebx
     8a1:	68 bc 16 00 00       	push   $0x16bc
     8a6:	ff 75 e0             	push   -0x20(%ebp)
     8a9:	e8 62 04 00 00       	call   d10 <printf>
    printf(stdout, "[--Caso 6.2] Child indo embora\n");
     8ae:	58                   	pop    %eax
     8af:	5a                   	pop    %edx
     8b0:	68 88 12 00 00       	push   $0x1288
     8b5:	ff 35 4c 1b 00 00    	push   0x1b4c
     8bb:	e8 50 04 00 00       	call   d10 <printf>
    close(fd[1]);
     8c0:	59                   	pop    %ecx
     8c1:	ff 75 e0             	push   -0x20(%ebp)
     8c4:	e8 f2 02 00 00       	call   bbb <close>
    exit();
     8c9:	e8 c5 02 00 00       	call   b93 <exit>
     8ce:	66 90                	xchg   %ax,%ax

000008d0 <get_date>:
int get_date(struct rtcdate *r) {
     8d0:	55                   	push   %ebp
     8d1:	89 e5                	mov    %esp,%ebp
     8d3:	83 ec 14             	sub    $0x14,%esp
  if (date(r)) {
     8d6:	ff 75 08             	push   0x8(%ebp)
     8d9:	e8 55 03 00 00       	call   c33 <date>
     8de:	83 c4 10             	add    $0x10,%esp
     8e1:	89 c2                	mov    %eax,%edx
     8e3:	b8 01 00 00 00       	mov    $0x1,%eax
     8e8:	85 d2                	test   %edx,%edx
     8ea:	75 04                	jne    8f0 <get_date+0x20>
}
     8ec:	c9                   	leave  
     8ed:	c3                   	ret    
     8ee:	66 90                	xchg   %ax,%ax
    printf(stderr, "[ERROR] Erro na chamada de sistema date\n");
     8f0:	83 ec 08             	sub    $0x8,%esp
     8f3:	68 ec 12 00 00       	push   $0x12ec
     8f8:	ff 35 48 1b 00 00    	push   0x1b48
     8fe:	e8 0d 04 00 00       	call   d10 <printf>
     903:	83 c4 10             	add    $0x10,%esp
     906:	31 c0                	xor    %eax,%eax
}
     908:	c9                   	leave  
     909:	c3                   	ret    
     90a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000910 <print_date>:
void print_date(struct rtcdate *r) {
     910:	55                   	push   %ebp
     911:	89 e5                	mov    %esp,%ebp
     913:	83 ec 08             	sub    $0x8,%esp
     916:	8b 45 08             	mov    0x8(%ebp),%eax
  printf(stdout, "%d/%d/%d %d:%d:%d\n", r->day,
     919:	ff 30                	push   (%eax)
     91b:	ff 70 04             	push   0x4(%eax)
     91e:	ff 70 08             	push   0x8(%eax)
     921:	ff 70 14             	push   0x14(%eax)
     924:	ff 70 10             	push   0x10(%eax)
     927:	ff 70 0c             	push   0xc(%eax)
     92a:	68 88 14 00 00       	push   $0x1488
     92f:	ff 35 4c 1b 00 00    	push   0x1b4c
     935:	e8 d6 03 00 00       	call   d10 <printf>
}
     93a:	83 c4 20             	add    $0x20,%esp
     93d:	c9                   	leave  
     93e:	c3                   	ret    
     93f:	90                   	nop

00000940 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
     940:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     941:	31 c0                	xor    %eax,%eax
{
     943:	89 e5                	mov    %esp,%ebp
     945:	53                   	push   %ebx
     946:	8b 4d 08             	mov    0x8(%ebp),%ecx
     949:	8b 5d 0c             	mov    0xc(%ebp),%ebx
     94c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
     950:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
     954:	88 14 01             	mov    %dl,(%ecx,%eax,1)
     957:	83 c0 01             	add    $0x1,%eax
     95a:	84 d2                	test   %dl,%dl
     95c:	75 f2                	jne    950 <strcpy+0x10>
    ;
  return os;
}
     95e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     961:	89 c8                	mov    %ecx,%eax
     963:	c9                   	leave  
     964:	c3                   	ret    
     965:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     96c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000970 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     970:	55                   	push   %ebp
     971:	89 e5                	mov    %esp,%ebp
     973:	53                   	push   %ebx
     974:	8b 55 08             	mov    0x8(%ebp),%edx
     977:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
     97a:	0f b6 02             	movzbl (%edx),%eax
     97d:	84 c0                	test   %al,%al
     97f:	75 17                	jne    998 <strcmp+0x28>
     981:	eb 3a                	jmp    9bd <strcmp+0x4d>
     983:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     987:	90                   	nop
     988:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
     98c:	83 c2 01             	add    $0x1,%edx
     98f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
     992:	84 c0                	test   %al,%al
     994:	74 1a                	je     9b0 <strcmp+0x40>
    p++, q++;
     996:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
     998:	0f b6 19             	movzbl (%ecx),%ebx
     99b:	38 c3                	cmp    %al,%bl
     99d:	74 e9                	je     988 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
     99f:	29 d8                	sub    %ebx,%eax
}
     9a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     9a4:	c9                   	leave  
     9a5:	c3                   	ret    
     9a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     9ad:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
     9b0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
     9b4:	31 c0                	xor    %eax,%eax
     9b6:	29 d8                	sub    %ebx,%eax
}
     9b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     9bb:	c9                   	leave  
     9bc:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
     9bd:	0f b6 19             	movzbl (%ecx),%ebx
     9c0:	31 c0                	xor    %eax,%eax
     9c2:	eb db                	jmp    99f <strcmp+0x2f>
     9c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     9cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     9cf:	90                   	nop

000009d0 <strlen>:

uint
strlen(const char *s)
{
     9d0:	55                   	push   %ebp
     9d1:	89 e5                	mov    %esp,%ebp
     9d3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
     9d6:	80 3a 00             	cmpb   $0x0,(%edx)
     9d9:	74 15                	je     9f0 <strlen+0x20>
     9db:	31 c0                	xor    %eax,%eax
     9dd:	8d 76 00             	lea    0x0(%esi),%esi
     9e0:	83 c0 01             	add    $0x1,%eax
     9e3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
     9e7:	89 c1                	mov    %eax,%ecx
     9e9:	75 f5                	jne    9e0 <strlen+0x10>
    ;
  return n;
}
     9eb:	89 c8                	mov    %ecx,%eax
     9ed:	5d                   	pop    %ebp
     9ee:	c3                   	ret    
     9ef:	90                   	nop
  for(n = 0; s[n]; n++)
     9f0:	31 c9                	xor    %ecx,%ecx
}
     9f2:	5d                   	pop    %ebp
     9f3:	89 c8                	mov    %ecx,%eax
     9f5:	c3                   	ret    
     9f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     9fd:	8d 76 00             	lea    0x0(%esi),%esi

00000a00 <memset>:

void*
memset(void *dst, int c, uint n)
{
     a00:	55                   	push   %ebp
     a01:	89 e5                	mov    %esp,%ebp
     a03:	57                   	push   %edi
     a04:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
     a07:	8b 4d 10             	mov    0x10(%ebp),%ecx
     a0a:	8b 45 0c             	mov    0xc(%ebp),%eax
     a0d:	89 d7                	mov    %edx,%edi
     a0f:	fc                   	cld    
     a10:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
     a12:	8b 7d fc             	mov    -0x4(%ebp),%edi
     a15:	89 d0                	mov    %edx,%eax
     a17:	c9                   	leave  
     a18:	c3                   	ret    
     a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000a20 <strchr>:

char*
strchr(const char *s, char c)
{
     a20:	55                   	push   %ebp
     a21:	89 e5                	mov    %esp,%ebp
     a23:	8b 45 08             	mov    0x8(%ebp),%eax
     a26:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
     a2a:	0f b6 10             	movzbl (%eax),%edx
     a2d:	84 d2                	test   %dl,%dl
     a2f:	75 12                	jne    a43 <strchr+0x23>
     a31:	eb 1d                	jmp    a50 <strchr+0x30>
     a33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     a37:	90                   	nop
     a38:	0f b6 50 01          	movzbl 0x1(%eax),%edx
     a3c:	83 c0 01             	add    $0x1,%eax
     a3f:	84 d2                	test   %dl,%dl
     a41:	74 0d                	je     a50 <strchr+0x30>
    if(*s == c)
     a43:	38 d1                	cmp    %dl,%cl
     a45:	75 f1                	jne    a38 <strchr+0x18>
      return (char*)s;
  return 0;
}
     a47:	5d                   	pop    %ebp
     a48:	c3                   	ret    
     a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
     a50:	31 c0                	xor    %eax,%eax
}
     a52:	5d                   	pop    %ebp
     a53:	c3                   	ret    
     a54:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     a5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     a5f:	90                   	nop

00000a60 <gets>:

char*
gets(char *buf, int max)
{
     a60:	55                   	push   %ebp
     a61:	89 e5                	mov    %esp,%ebp
     a63:	57                   	push   %edi
     a64:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
     a65:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
     a68:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
     a69:	31 db                	xor    %ebx,%ebx
{
     a6b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
     a6e:	eb 27                	jmp    a97 <gets+0x37>
    cc = read(0, &c, 1);
     a70:	83 ec 04             	sub    $0x4,%esp
     a73:	6a 01                	push   $0x1
     a75:	57                   	push   %edi
     a76:	6a 00                	push   $0x0
     a78:	e8 2e 01 00 00       	call   bab <read>
    if(cc < 1)
     a7d:	83 c4 10             	add    $0x10,%esp
     a80:	85 c0                	test   %eax,%eax
     a82:	7e 1d                	jle    aa1 <gets+0x41>
      break;
    buf[i++] = c;
     a84:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
     a88:	8b 55 08             	mov    0x8(%ebp),%edx
     a8b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
     a8f:	3c 0a                	cmp    $0xa,%al
     a91:	74 1d                	je     ab0 <gets+0x50>
     a93:	3c 0d                	cmp    $0xd,%al
     a95:	74 19                	je     ab0 <gets+0x50>
  for(i=0; i+1 < max; ){
     a97:	89 de                	mov    %ebx,%esi
     a99:	83 c3 01             	add    $0x1,%ebx
     a9c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
     a9f:	7c cf                	jl     a70 <gets+0x10>
      break;
  }
  buf[i] = '\0';
     aa1:	8b 45 08             	mov    0x8(%ebp),%eax
     aa4:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
     aa8:	8d 65 f4             	lea    -0xc(%ebp),%esp
     aab:	5b                   	pop    %ebx
     aac:	5e                   	pop    %esi
     aad:	5f                   	pop    %edi
     aae:	5d                   	pop    %ebp
     aaf:	c3                   	ret    
  buf[i] = '\0';
     ab0:	8b 45 08             	mov    0x8(%ebp),%eax
     ab3:	89 de                	mov    %ebx,%esi
     ab5:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
     ab9:	8d 65 f4             	lea    -0xc(%ebp),%esp
     abc:	5b                   	pop    %ebx
     abd:	5e                   	pop    %esi
     abe:	5f                   	pop    %edi
     abf:	5d                   	pop    %ebp
     ac0:	c3                   	ret    
     ac1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     ac8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     acf:	90                   	nop

00000ad0 <stat>:

int
stat(const char *n, struct stat *st)
{
     ad0:	55                   	push   %ebp
     ad1:	89 e5                	mov    %esp,%ebp
     ad3:	56                   	push   %esi
     ad4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     ad5:	83 ec 08             	sub    $0x8,%esp
     ad8:	6a 00                	push   $0x0
     ada:	ff 75 08             	push   0x8(%ebp)
     add:	e8 f1 00 00 00       	call   bd3 <open>
  if(fd < 0)
     ae2:	83 c4 10             	add    $0x10,%esp
     ae5:	85 c0                	test   %eax,%eax
     ae7:	78 27                	js     b10 <stat+0x40>
    return -1;
  r = fstat(fd, st);
     ae9:	83 ec 08             	sub    $0x8,%esp
     aec:	ff 75 0c             	push   0xc(%ebp)
     aef:	89 c3                	mov    %eax,%ebx
     af1:	50                   	push   %eax
     af2:	e8 f4 00 00 00       	call   beb <fstat>
  close(fd);
     af7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
     afa:	89 c6                	mov    %eax,%esi
  close(fd);
     afc:	e8 ba 00 00 00       	call   bbb <close>
  return r;
     b01:	83 c4 10             	add    $0x10,%esp
}
     b04:	8d 65 f8             	lea    -0x8(%ebp),%esp
     b07:	89 f0                	mov    %esi,%eax
     b09:	5b                   	pop    %ebx
     b0a:	5e                   	pop    %esi
     b0b:	5d                   	pop    %ebp
     b0c:	c3                   	ret    
     b0d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
     b10:	be ff ff ff ff       	mov    $0xffffffff,%esi
     b15:	eb ed                	jmp    b04 <stat+0x34>
     b17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     b1e:	66 90                	xchg   %ax,%ax

00000b20 <atoi>:

int
atoi(const char *s)
{
     b20:	55                   	push   %ebp
     b21:	89 e5                	mov    %esp,%ebp
     b23:	53                   	push   %ebx
     b24:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     b27:	0f be 02             	movsbl (%edx),%eax
     b2a:	8d 48 d0             	lea    -0x30(%eax),%ecx
     b2d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
     b30:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
     b35:	77 1e                	ja     b55 <atoi+0x35>
     b37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     b3e:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
     b40:	83 c2 01             	add    $0x1,%edx
     b43:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
     b46:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
     b4a:	0f be 02             	movsbl (%edx),%eax
     b4d:	8d 58 d0             	lea    -0x30(%eax),%ebx
     b50:	80 fb 09             	cmp    $0x9,%bl
     b53:	76 eb                	jbe    b40 <atoi+0x20>
  return n;
}
     b55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     b58:	89 c8                	mov    %ecx,%eax
     b5a:	c9                   	leave  
     b5b:	c3                   	ret    
     b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000b60 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     b60:	55                   	push   %ebp
     b61:	89 e5                	mov    %esp,%ebp
     b63:	57                   	push   %edi
     b64:	8b 45 10             	mov    0x10(%ebp),%eax
     b67:	8b 55 08             	mov    0x8(%ebp),%edx
     b6a:	56                   	push   %esi
     b6b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     b6e:	85 c0                	test   %eax,%eax
     b70:	7e 13                	jle    b85 <memmove+0x25>
     b72:	01 d0                	add    %edx,%eax
  dst = vdst;
     b74:	89 d7                	mov    %edx,%edi
     b76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     b7d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
     b80:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
     b81:	39 f8                	cmp    %edi,%eax
     b83:	75 fb                	jne    b80 <memmove+0x20>
  return vdst;
}
     b85:	5e                   	pop    %esi
     b86:	89 d0                	mov    %edx,%eax
     b88:	5f                   	pop    %edi
     b89:	5d                   	pop    %ebp
     b8a:	c3                   	ret    

00000b8b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     b8b:	b8 01 00 00 00       	mov    $0x1,%eax
     b90:	cd 40                	int    $0x40
     b92:	c3                   	ret    

00000b93 <exit>:
SYSCALL(exit)
     b93:	b8 02 00 00 00       	mov    $0x2,%eax
     b98:	cd 40                	int    $0x40
     b9a:	c3                   	ret    

00000b9b <wait>:
SYSCALL(wait)
     b9b:	b8 03 00 00 00       	mov    $0x3,%eax
     ba0:	cd 40                	int    $0x40
     ba2:	c3                   	ret    

00000ba3 <pipe>:
SYSCALL(pipe)
     ba3:	b8 04 00 00 00       	mov    $0x4,%eax
     ba8:	cd 40                	int    $0x40
     baa:	c3                   	ret    

00000bab <read>:
SYSCALL(read)
     bab:	b8 05 00 00 00       	mov    $0x5,%eax
     bb0:	cd 40                	int    $0x40
     bb2:	c3                   	ret    

00000bb3 <write>:
SYSCALL(write)
     bb3:	b8 10 00 00 00       	mov    $0x10,%eax
     bb8:	cd 40                	int    $0x40
     bba:	c3                   	ret    

00000bbb <close>:
SYSCALL(close)
     bbb:	b8 15 00 00 00       	mov    $0x15,%eax
     bc0:	cd 40                	int    $0x40
     bc2:	c3                   	ret    

00000bc3 <kill>:
SYSCALL(kill)
     bc3:	b8 06 00 00 00       	mov    $0x6,%eax
     bc8:	cd 40                	int    $0x40
     bca:	c3                   	ret    

00000bcb <exec>:
SYSCALL(exec)
     bcb:	b8 07 00 00 00       	mov    $0x7,%eax
     bd0:	cd 40                	int    $0x40
     bd2:	c3                   	ret    

00000bd3 <open>:
SYSCALL(open)
     bd3:	b8 0f 00 00 00       	mov    $0xf,%eax
     bd8:	cd 40                	int    $0x40
     bda:	c3                   	ret    

00000bdb <mknod>:
SYSCALL(mknod)
     bdb:	b8 11 00 00 00       	mov    $0x11,%eax
     be0:	cd 40                	int    $0x40
     be2:	c3                   	ret    

00000be3 <unlink>:
SYSCALL(unlink)
     be3:	b8 12 00 00 00       	mov    $0x12,%eax
     be8:	cd 40                	int    $0x40
     bea:	c3                   	ret    

00000beb <fstat>:
SYSCALL(fstat)
     beb:	b8 08 00 00 00       	mov    $0x8,%eax
     bf0:	cd 40                	int    $0x40
     bf2:	c3                   	ret    

00000bf3 <link>:
SYSCALL(link)
     bf3:	b8 13 00 00 00       	mov    $0x13,%eax
     bf8:	cd 40                	int    $0x40
     bfa:	c3                   	ret    

00000bfb <mkdir>:
SYSCALL(mkdir)
     bfb:	b8 14 00 00 00       	mov    $0x14,%eax
     c00:	cd 40                	int    $0x40
     c02:	c3                   	ret    

00000c03 <chdir>:
SYSCALL(chdir)
     c03:	b8 09 00 00 00       	mov    $0x9,%eax
     c08:	cd 40                	int    $0x40
     c0a:	c3                   	ret    

00000c0b <dup>:
SYSCALL(dup)
     c0b:	b8 0a 00 00 00       	mov    $0xa,%eax
     c10:	cd 40                	int    $0x40
     c12:	c3                   	ret    

00000c13 <getpid>:
SYSCALL(getpid)
     c13:	b8 0b 00 00 00       	mov    $0xb,%eax
     c18:	cd 40                	int    $0x40
     c1a:	c3                   	ret    

00000c1b <sbrk>:
SYSCALL(sbrk)
     c1b:	b8 0c 00 00 00       	mov    $0xc,%eax
     c20:	cd 40                	int    $0x40
     c22:	c3                   	ret    

00000c23 <sleep>:
SYSCALL(sleep)
     c23:	b8 0d 00 00 00       	mov    $0xd,%eax
     c28:	cd 40                	int    $0x40
     c2a:	c3                   	ret    

00000c2b <uptime>:
SYSCALL(uptime)
     c2b:	b8 0e 00 00 00       	mov    $0xe,%eax
     c30:	cd 40                	int    $0x40
     c32:	c3                   	ret    

00000c33 <date>:
SYSCALL(date)
     c33:	b8 16 00 00 00       	mov    $0x16,%eax
     c38:	cd 40                	int    $0x40
     c3a:	c3                   	ret    

00000c3b <virt2real>:
SYSCALL(virt2real)
     c3b:	b8 17 00 00 00       	mov    $0x17,%eax
     c40:	cd 40                	int    $0x40
     c42:	c3                   	ret    

00000c43 <num_pages>:
SYSCALL(num_pages)
     c43:	b8 18 00 00 00       	mov    $0x18,%eax
     c48:	cd 40                	int    $0x40
     c4a:	c3                   	ret    

00000c4b <forkcow>:
SYSCALL(forkcow)
     c4b:	b8 19 00 00 00       	mov    $0x19,%eax
     c50:	cd 40                	int    $0x40
     c52:	c3                   	ret    
     c53:	66 90                	xchg   %ax,%ax
     c55:	66 90                	xchg   %ax,%ax
     c57:	66 90                	xchg   %ax,%ax
     c59:	66 90                	xchg   %ax,%ax
     c5b:	66 90                	xchg   %ax,%ax
     c5d:	66 90                	xchg   %ax,%ax
     c5f:	90                   	nop

00000c60 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
     c60:	55                   	push   %ebp
     c61:	89 e5                	mov    %esp,%ebp
     c63:	57                   	push   %edi
     c64:	56                   	push   %esi
     c65:	53                   	push   %ebx
     c66:	83 ec 3c             	sub    $0x3c,%esp
     c69:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
     c6c:	89 d1                	mov    %edx,%ecx
{
     c6e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
     c71:	85 d2                	test   %edx,%edx
     c73:	0f 89 7f 00 00 00    	jns    cf8 <printint+0x98>
     c79:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
     c7d:	74 79                	je     cf8 <printint+0x98>
    neg = 1;
     c7f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
     c86:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
     c88:	31 db                	xor    %ebx,%ebx
     c8a:	8d 75 d7             	lea    -0x29(%ebp),%esi
     c8d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
     c90:	89 c8                	mov    %ecx,%eax
     c92:	31 d2                	xor    %edx,%edx
     c94:	89 cf                	mov    %ecx,%edi
     c96:	f7 75 c4             	divl   -0x3c(%ebp)
     c99:	0f b6 92 24 17 00 00 	movzbl 0x1724(%edx),%edx
     ca0:	89 45 c0             	mov    %eax,-0x40(%ebp)
     ca3:	89 d8                	mov    %ebx,%eax
     ca5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
     ca8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
     cab:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
     cae:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
     cb1:	76 dd                	jbe    c90 <printint+0x30>
  if(neg)
     cb3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
     cb6:	85 c9                	test   %ecx,%ecx
     cb8:	74 0c                	je     cc6 <printint+0x66>
    buf[i++] = '-';
     cba:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
     cbf:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
     cc1:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
     cc6:	8b 7d b8             	mov    -0x48(%ebp),%edi
     cc9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
     ccd:	eb 07                	jmp    cd6 <printint+0x76>
     ccf:	90                   	nop
    putc(fd, buf[i]);
     cd0:	0f b6 13             	movzbl (%ebx),%edx
     cd3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
     cd6:	83 ec 04             	sub    $0x4,%esp
     cd9:	88 55 d7             	mov    %dl,-0x29(%ebp)
     cdc:	6a 01                	push   $0x1
     cde:	56                   	push   %esi
     cdf:	57                   	push   %edi
     ce0:	e8 ce fe ff ff       	call   bb3 <write>
  while(--i >= 0)
     ce5:	83 c4 10             	add    $0x10,%esp
     ce8:	39 de                	cmp    %ebx,%esi
     cea:	75 e4                	jne    cd0 <printint+0x70>
}
     cec:	8d 65 f4             	lea    -0xc(%ebp),%esp
     cef:	5b                   	pop    %ebx
     cf0:	5e                   	pop    %esi
     cf1:	5f                   	pop    %edi
     cf2:	5d                   	pop    %ebp
     cf3:	c3                   	ret    
     cf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
     cf8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
     cff:	eb 87                	jmp    c88 <printint+0x28>
     d01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     d08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     d0f:	90                   	nop

00000d10 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
     d10:	55                   	push   %ebp
     d11:	89 e5                	mov    %esp,%ebp
     d13:	57                   	push   %edi
     d14:	56                   	push   %esi
     d15:	53                   	push   %ebx
     d16:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     d19:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
     d1c:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
     d1f:	0f b6 13             	movzbl (%ebx),%edx
     d22:	84 d2                	test   %dl,%dl
     d24:	74 6a                	je     d90 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
     d26:	8d 45 10             	lea    0x10(%ebp),%eax
     d29:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
     d2c:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
     d2f:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
     d31:	89 45 d0             	mov    %eax,-0x30(%ebp)
     d34:	eb 36                	jmp    d6c <printf+0x5c>
     d36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     d3d:	8d 76 00             	lea    0x0(%esi),%esi
     d40:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
     d43:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
     d48:	83 f8 25             	cmp    $0x25,%eax
     d4b:	74 15                	je     d62 <printf+0x52>
  write(fd, &c, 1);
     d4d:	83 ec 04             	sub    $0x4,%esp
     d50:	88 55 e7             	mov    %dl,-0x19(%ebp)
     d53:	6a 01                	push   $0x1
     d55:	57                   	push   %edi
     d56:	56                   	push   %esi
     d57:	e8 57 fe ff ff       	call   bb3 <write>
     d5c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
     d5f:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
     d62:	0f b6 13             	movzbl (%ebx),%edx
     d65:	83 c3 01             	add    $0x1,%ebx
     d68:	84 d2                	test   %dl,%dl
     d6a:	74 24                	je     d90 <printf+0x80>
    c = fmt[i] & 0xff;
     d6c:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
     d6f:	85 c9                	test   %ecx,%ecx
     d71:	74 cd                	je     d40 <printf+0x30>
      }
    } else if(state == '%'){
     d73:	83 f9 25             	cmp    $0x25,%ecx
     d76:	75 ea                	jne    d62 <printf+0x52>
      if(c == 'd'){
     d78:	83 f8 25             	cmp    $0x25,%eax
     d7b:	0f 84 07 01 00 00    	je     e88 <printf+0x178>
     d81:	83 e8 63             	sub    $0x63,%eax
     d84:	83 f8 15             	cmp    $0x15,%eax
     d87:	77 17                	ja     da0 <printf+0x90>
     d89:	ff 24 85 cc 16 00 00 	jmp    *0x16cc(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
     d90:	8d 65 f4             	lea    -0xc(%ebp),%esp
     d93:	5b                   	pop    %ebx
     d94:	5e                   	pop    %esi
     d95:	5f                   	pop    %edi
     d96:	5d                   	pop    %ebp
     d97:	c3                   	ret    
     d98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     d9f:	90                   	nop
  write(fd, &c, 1);
     da0:	83 ec 04             	sub    $0x4,%esp
     da3:	88 55 d4             	mov    %dl,-0x2c(%ebp)
     da6:	6a 01                	push   $0x1
     da8:	57                   	push   %edi
     da9:	56                   	push   %esi
     daa:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
     dae:	e8 00 fe ff ff       	call   bb3 <write>
        putc(fd, c);
     db3:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
     db7:	83 c4 0c             	add    $0xc,%esp
     dba:	88 55 e7             	mov    %dl,-0x19(%ebp)
     dbd:	6a 01                	push   $0x1
     dbf:	57                   	push   %edi
     dc0:	56                   	push   %esi
     dc1:	e8 ed fd ff ff       	call   bb3 <write>
        putc(fd, c);
     dc6:	83 c4 10             	add    $0x10,%esp
      state = 0;
     dc9:	31 c9                	xor    %ecx,%ecx
     dcb:	eb 95                	jmp    d62 <printf+0x52>
     dcd:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
     dd0:	83 ec 0c             	sub    $0xc,%esp
     dd3:	b9 10 00 00 00       	mov    $0x10,%ecx
     dd8:	6a 00                	push   $0x0
     dda:	8b 45 d0             	mov    -0x30(%ebp),%eax
     ddd:	8b 10                	mov    (%eax),%edx
     ddf:	89 f0                	mov    %esi,%eax
     de1:	e8 7a fe ff ff       	call   c60 <printint>
        ap++;
     de6:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
     dea:	83 c4 10             	add    $0x10,%esp
      state = 0;
     ded:	31 c9                	xor    %ecx,%ecx
     def:	e9 6e ff ff ff       	jmp    d62 <printf+0x52>
     df4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
     df8:	8b 45 d0             	mov    -0x30(%ebp),%eax
     dfb:	8b 10                	mov    (%eax),%edx
        ap++;
     dfd:	83 c0 04             	add    $0x4,%eax
     e00:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
     e03:	85 d2                	test   %edx,%edx
     e05:	0f 84 8d 00 00 00    	je     e98 <printf+0x188>
        while(*s != 0){
     e0b:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
     e0e:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
     e10:	84 c0                	test   %al,%al
     e12:	0f 84 4a ff ff ff    	je     d62 <printf+0x52>
     e18:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
     e1b:	89 d3                	mov    %edx,%ebx
     e1d:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
     e20:	83 ec 04             	sub    $0x4,%esp
          s++;
     e23:	83 c3 01             	add    $0x1,%ebx
     e26:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
     e29:	6a 01                	push   $0x1
     e2b:	57                   	push   %edi
     e2c:	56                   	push   %esi
     e2d:	e8 81 fd ff ff       	call   bb3 <write>
        while(*s != 0){
     e32:	0f b6 03             	movzbl (%ebx),%eax
     e35:	83 c4 10             	add    $0x10,%esp
     e38:	84 c0                	test   %al,%al
     e3a:	75 e4                	jne    e20 <printf+0x110>
      state = 0;
     e3c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
     e3f:	31 c9                	xor    %ecx,%ecx
     e41:	e9 1c ff ff ff       	jmp    d62 <printf+0x52>
     e46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     e4d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
     e50:	83 ec 0c             	sub    $0xc,%esp
     e53:	b9 0a 00 00 00       	mov    $0xa,%ecx
     e58:	6a 01                	push   $0x1
     e5a:	e9 7b ff ff ff       	jmp    dda <printf+0xca>
     e5f:	90                   	nop
        putc(fd, *ap);
     e60:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
     e63:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
     e66:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
     e68:	6a 01                	push   $0x1
     e6a:	57                   	push   %edi
     e6b:	56                   	push   %esi
        putc(fd, *ap);
     e6c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
     e6f:	e8 3f fd ff ff       	call   bb3 <write>
        ap++;
     e74:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
     e78:	83 c4 10             	add    $0x10,%esp
      state = 0;
     e7b:	31 c9                	xor    %ecx,%ecx
     e7d:	e9 e0 fe ff ff       	jmp    d62 <printf+0x52>
     e82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
     e88:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
     e8b:	83 ec 04             	sub    $0x4,%esp
     e8e:	e9 2a ff ff ff       	jmp    dbd <printf+0xad>
     e93:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     e97:	90                   	nop
          s = "(null)";
     e98:	ba c4 16 00 00       	mov    $0x16c4,%edx
        while(*s != 0){
     e9d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
     ea0:	b8 28 00 00 00       	mov    $0x28,%eax
     ea5:	89 d3                	mov    %edx,%ebx
     ea7:	e9 74 ff ff ff       	jmp    e20 <printf+0x110>
     eac:	66 90                	xchg   %ax,%ax
     eae:	66 90                	xchg   %ax,%ax

00000eb0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     eb0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     eb1:	a1 50 1b 00 00       	mov    0x1b50,%eax
{
     eb6:	89 e5                	mov    %esp,%ebp
     eb8:	57                   	push   %edi
     eb9:	56                   	push   %esi
     eba:	53                   	push   %ebx
     ebb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
     ebe:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     ec1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     ec8:	89 c2                	mov    %eax,%edx
     eca:	8b 00                	mov    (%eax),%eax
     ecc:	39 ca                	cmp    %ecx,%edx
     ece:	73 30                	jae    f00 <free+0x50>
     ed0:	39 c1                	cmp    %eax,%ecx
     ed2:	72 04                	jb     ed8 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     ed4:	39 c2                	cmp    %eax,%edx
     ed6:	72 f0                	jb     ec8 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
     ed8:	8b 73 fc             	mov    -0x4(%ebx),%esi
     edb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
     ede:	39 f8                	cmp    %edi,%eax
     ee0:	74 30                	je     f12 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
     ee2:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
     ee5:	8b 42 04             	mov    0x4(%edx),%eax
     ee8:	8d 34 c2             	lea    (%edx,%eax,8),%esi
     eeb:	39 f1                	cmp    %esi,%ecx
     eed:	74 3a                	je     f29 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
     eef:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
     ef1:	5b                   	pop    %ebx
  freep = p;
     ef2:	89 15 50 1b 00 00    	mov    %edx,0x1b50
}
     ef8:	5e                   	pop    %esi
     ef9:	5f                   	pop    %edi
     efa:	5d                   	pop    %ebp
     efb:	c3                   	ret    
     efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     f00:	39 c2                	cmp    %eax,%edx
     f02:	72 c4                	jb     ec8 <free+0x18>
     f04:	39 c1                	cmp    %eax,%ecx
     f06:	73 c0                	jae    ec8 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
     f08:	8b 73 fc             	mov    -0x4(%ebx),%esi
     f0b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
     f0e:	39 f8                	cmp    %edi,%eax
     f10:	75 d0                	jne    ee2 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
     f12:	03 70 04             	add    0x4(%eax),%esi
     f15:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
     f18:	8b 02                	mov    (%edx),%eax
     f1a:	8b 00                	mov    (%eax),%eax
     f1c:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
     f1f:	8b 42 04             	mov    0x4(%edx),%eax
     f22:	8d 34 c2             	lea    (%edx,%eax,8),%esi
     f25:	39 f1                	cmp    %esi,%ecx
     f27:	75 c6                	jne    eef <free+0x3f>
    p->s.size += bp->s.size;
     f29:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
     f2c:	89 15 50 1b 00 00    	mov    %edx,0x1b50
    p->s.size += bp->s.size;
     f32:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
     f35:	8b 4b f8             	mov    -0x8(%ebx),%ecx
     f38:	89 0a                	mov    %ecx,(%edx)
}
     f3a:	5b                   	pop    %ebx
     f3b:	5e                   	pop    %esi
     f3c:	5f                   	pop    %edi
     f3d:	5d                   	pop    %ebp
     f3e:	c3                   	ret    
     f3f:	90                   	nop

00000f40 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
     f40:	55                   	push   %ebp
     f41:	89 e5                	mov    %esp,%ebp
     f43:	57                   	push   %edi
     f44:	56                   	push   %esi
     f45:	53                   	push   %ebx
     f46:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     f49:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
     f4c:	8b 3d 50 1b 00 00    	mov    0x1b50,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     f52:	8d 70 07             	lea    0x7(%eax),%esi
     f55:	c1 ee 03             	shr    $0x3,%esi
     f58:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
     f5b:	85 ff                	test   %edi,%edi
     f5d:	0f 84 9d 00 00 00    	je     1000 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     f63:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
     f65:	8b 4a 04             	mov    0x4(%edx),%ecx
     f68:	39 f1                	cmp    %esi,%ecx
     f6a:	73 6a                	jae    fd6 <malloc+0x96>
     f6c:	bb 00 10 00 00       	mov    $0x1000,%ebx
     f71:	39 de                	cmp    %ebx,%esi
     f73:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
     f76:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
     f7d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
     f80:	eb 17                	jmp    f99 <malloc+0x59>
     f82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     f88:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
     f8a:	8b 48 04             	mov    0x4(%eax),%ecx
     f8d:	39 f1                	cmp    %esi,%ecx
     f8f:	73 4f                	jae    fe0 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
     f91:	8b 3d 50 1b 00 00    	mov    0x1b50,%edi
     f97:	89 c2                	mov    %eax,%edx
     f99:	39 d7                	cmp    %edx,%edi
     f9b:	75 eb                	jne    f88 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
     f9d:	83 ec 0c             	sub    $0xc,%esp
     fa0:	ff 75 e4             	push   -0x1c(%ebp)
     fa3:	e8 73 fc ff ff       	call   c1b <sbrk>
  if(p == (char*)-1)
     fa8:	83 c4 10             	add    $0x10,%esp
     fab:	83 f8 ff             	cmp    $0xffffffff,%eax
     fae:	74 1c                	je     fcc <malloc+0x8c>
  hp->s.size = nu;
     fb0:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
     fb3:	83 ec 0c             	sub    $0xc,%esp
     fb6:	83 c0 08             	add    $0x8,%eax
     fb9:	50                   	push   %eax
     fba:	e8 f1 fe ff ff       	call   eb0 <free>
  return freep;
     fbf:	8b 15 50 1b 00 00    	mov    0x1b50,%edx
      if((p = morecore(nunits)) == 0)
     fc5:	83 c4 10             	add    $0x10,%esp
     fc8:	85 d2                	test   %edx,%edx
     fca:	75 bc                	jne    f88 <malloc+0x48>
        return 0;
  }
}
     fcc:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
     fcf:	31 c0                	xor    %eax,%eax
}
     fd1:	5b                   	pop    %ebx
     fd2:	5e                   	pop    %esi
     fd3:	5f                   	pop    %edi
     fd4:	5d                   	pop    %ebp
     fd5:	c3                   	ret    
    if(p->s.size >= nunits){
     fd6:	89 d0                	mov    %edx,%eax
     fd8:	89 fa                	mov    %edi,%edx
     fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
     fe0:	39 ce                	cmp    %ecx,%esi
     fe2:	74 4c                	je     1030 <malloc+0xf0>
        p->s.size -= nunits;
     fe4:	29 f1                	sub    %esi,%ecx
     fe6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
     fe9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
     fec:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
     fef:	89 15 50 1b 00 00    	mov    %edx,0x1b50
}
     ff5:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
     ff8:	83 c0 08             	add    $0x8,%eax
}
     ffb:	5b                   	pop    %ebx
     ffc:	5e                   	pop    %esi
     ffd:	5f                   	pop    %edi
     ffe:	5d                   	pop    %ebp
     fff:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
    1000:	c7 05 50 1b 00 00 54 	movl   $0x1b54,0x1b50
    1007:	1b 00 00 
    base.s.size = 0;
    100a:	bf 54 1b 00 00       	mov    $0x1b54,%edi
    base.s.ptr = freep = prevp = &base;
    100f:	c7 05 54 1b 00 00 54 	movl   $0x1b54,0x1b54
    1016:	1b 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1019:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
    101b:	c7 05 58 1b 00 00 00 	movl   $0x0,0x1b58
    1022:	00 00 00 
    if(p->s.size >= nunits){
    1025:	e9 42 ff ff ff       	jmp    f6c <malloc+0x2c>
    102a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
    1030:	8b 08                	mov    (%eax),%ecx
    1032:	89 0a                	mov    %ecx,(%edx)
    1034:	eb b9                	jmp    fef <malloc+0xaf>
