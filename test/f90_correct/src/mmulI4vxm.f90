!** Copyright (c) 1989, NVIDIA CORPORATION.  All rights reserved.
!**
!** Licensed under the Apache License, Version 2.0 (the "License");
!** you may not use this file except in compliance with the License.
!** You may obtain a copy of the License at
!**
!**     http://www.apache.org/licenses/LICENSE-2.0
!**
!** Unless required by applicable law or agreed to in writing, software
!** distributed under the License is distributed on an "AS IS" BASIS,
!** WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
!** See the License for the specific language governing permissions and
!** limitations under the License.

!* Tests for runtime library MATMUL routines

program p

  parameter(NbrTests=1418)
  
  integer*4, dimension(3) :: arr1
  integer*4, dimension(3,4) :: arr2
  integer*4, dimension(4) :: arr3
  integer*4, dimension(4,4) :: arr4
  integer*4, dimension(0:3,-1:1) :: arr5
  integer*4, dimension(-3:-1) :: arr6
  integer*4, dimension(-1:2,0:3) :: arr7
  integer*4, dimension(3) :: arr8
  integer*4, dimension(2:4,4) :: arr9
  integer*4, dimension(4) :: arr10
  integer*4, dimension(3,2:5) :: arr11
  integer*4, dimension(4) :: arr12
  integer*4, dimension(11) :: arr20
  integer*4, dimension(11) :: arr13
  integer*4, dimension(11,11) :: arr14
  integer*4, dimension(2,11) :: arr15
  integer*4, dimension(389) :: arr16
  integer*4, dimension(389,387) :: arr17
  integer*4, dimension(387) :: arr18
  integer*4, dimension(2,387) :: arr19
  
  data arr1 /0,1,2/
  data arr5 /0,1,2,3,4,5,6,7,8,9,10,11/
  data arr2 /0,1,2,3,4,5,6,7,8,9,10,11/
  data arr6 /0,1,2/
  data arr3 /0,1,2,3/
  data arr4 /0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15/
  data arr7 /0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15/
  data arr8 /0,1,2/
  data arr9 /0,1,2,3,4,5,6,7,8,9,10,11/
  data arr11 /0,1,2,3,4,5,6,7,8,9,10,11/
  data arr10 /0,1,2,3/
  
  integer*4 :: expect(NbrTests)
  integer*4 :: results(NbrTests)
  
  data expect / &
  ! tests 1-4
      5, 14, 23, 32, &
  ! tests 5-8
      0, 14, 23, 32, &
  ! tests 9-12
      14, 23, 32, 0, &
  ! tests 13-16
      0, 5, 14, 23, &
  ! tests 17-20
      0, 4, 7, 10, &
  ! tests 21-24
      2, 5, 8, 11, &
  ! tests 25-28
      2, 11, 20, 29, &
  ! tests 29-32
      0, 2, 11, 20, &
  ! tests 33-36
      5, 8, 11, 0, &
  ! tests 37-40
      10, 16, 22, 0, &
  ! tests 41-44
      0, 2, 0, 20, &
  ! tests 45-48
      5, 0, 11, 0, &
  ! tests 49-64
      0, 5, 0, 0, 0, 0, 0, 0, 0, &
      11, 0, 0, 0, 0, 0, 0, &
  ! tests 65-80
      0, 0, 0, 0, 0, 0, 0, 0, 5, &
      0, 11, 0, 0, 0, 0, 0, &
  ! tests 81-96
    0, 7, 0, 0, 0, 0, 0, 0, 0, &
    11, 0, 0, 0, 0, 0, 0, &
  ! tests 97-112
      0, 0, 0, 0, 0, 0, 0, 0, 19, &
      0, 31, 0, 0, 0, 0, 0, &
  ! tests 113-116
      18, 12, 6, 0, &
  ! tests 117-120
      0, 1, 0, 19, &
  ! tests 121-136
      0, 4, 0, 0, 0, 0, 0, 0, 0, &
      10, 0, 0, 0, 0, 0, 0, &
  ! tests 137-152
      0, 0, 0, 0, 0, 0, 0, 0, 11, &
      0, 5, 0, 0, 0, 0, 0, &
  ! tests 153-168
    0, 11, 0, 0, 0, 0, 0, 0, 0, &
    7, 0, 0, 0, 0, 0, 0, &
  ! tests 169-184
      0, 0, 0, 0, 0, 0, 0, 0, 31, &
      0, 19, 0, 0, 0, 0, 0, &
  ! tests 185-188
      5, 14, 23, 32, &
  ! tests 187-192
      5, 14, 23, 32, &
 ! tests 193-196
      14, 23, 32, 0, &
  ! tests 197-200
      0, 5, 14, 23, &
  ! tests 201-204
      0, 4, 7, 10, &
  ! tests 205-208
      2, 5, 8, 11, &
  ! tests 209-212
      2, 11, 20, 29, &
  ! tests 213-216
      0, 2, 11, 20, &
  ! tests 217-220
      5, 8, 11, 0, &
  ! tests 221-224
      10, 16, 22, 0, &
  ! test 225-235
      36, 72.0, 108.0,  &
      144, 180.0, 216.0,  &
      252, 288.0, 324.0,  &
      360, 396.0,  &
  ! test 236-257
      36, 0.0, 72.0,  &
      0, 108.0, 0.0,  &
      144, 0.0, 180.0,  &
      0, 216.0, 0.0,  &
      252, 0.0, 288.0,  &
      0, 324.0, 0.0,  &
      360, 0.0, 396.0,  &
      0,  &
  ! test 258-644
      38025, 76050.0, 114075.0,  &
      152100, 190125.0, 228150.0,  &
      266175, 304200.0, 342225.0,  &
      380250, 418275.0, 456300.0,  &
      494325, 532350.0, 570375.0,  &
      608400, 646425.0, 684450.0,  &
      722475, 760500.0, 798525.0,  &
      836550, 874575.0, 912600.0,  &
      950625, 988650.0, 1026675.0,  &
      1064700, 1102725.0, 1140750.0,  &
      1178775, 1216800.0, 1254825.0,  &
      1292850, 1330875.0, 1368900.0,  &
      1406925, 1444950.0, 1482975.0,  &
      1521000, 1559025.0, 1597050.0,  &
      1635075, 1673100.0, 1711125.0,  &
      1749150, 1787175.0, 1825200.0,  &
      1863225, 1901250.0, 1939275.0,  &
      1977300, 2015325.0, 2053350.0,  &
      2091375, 2129400.0, 2167425.0,  &
      2205450, 2243475.0, 2281500.0,  &
      2319525, 2357550.0, 2395575.0,  &
      2433600, 2471625.0, 2509650.0,  &
      2547675, 2585700.0, 2623725.0,  &
      2661750, 2699775.0, 2737800.0,  &
      2775825, 2813850.0, 2851875.0,  &
      2889900, 2927925.0, 2965950.0,  &
      3003975, 3042000.0, 3080025.0,  &
      3118050, 3156075.0, 3194100.0,  &
      3232125, 3270150.0, 3308175.0,  &
      3346200, 3384225.0, 3422250.0,  &
      3460275, 3498300.0, 3536325.0,  &
      3574350, 3612375.0, 3650400.0,  &
      3688425, 3726450.0, 3764475.0,  &
      3802500, 3840525.0, 3878550.0,  &
      3916575, 3954600.0, 3992625.0,  &
      4030650, 4068675.0, 4106700.0,  &
      4144725, 4182750.0, 4220775.0,  &
      4258800, 4296825.0, 4334850.0,  &
      4372875, 4410900.0, 4448925.0,  &
      4486950, 4524975.0, 4563000.0,  &
      4601025, 4639050.0, 4677075.0,  &
      4715100, 4753125.0, 4791150.0,  &
      4829175, 4867200.0, 4905225.0,  &
      4943250, 4981275.0, 5019300.0,  &
      5057325, 5095350.0, 5133375.0,  &
      5171400, 5209425.0, 5247450.0,  &
      5285475, 5323500.0, 5361525.0,  &
      5399550, 5437575.0, 5475600.0,  &
      5513625, 5551650.0, 5589675.0,  &
      5627700, 5665725.0, 5703750.0,  &
      5741775, 5779800.0, 5817825.0,  &
      5855850, 5893875.0, 5931900.0,  &
      5969925, 6007950.0, 6045975.0,  &
      6084000, 6122025.0, 6160050.0,  &
      6198075, 6236100.0, 6274125.0,  &
      6312150, 6350175.0, 6388200.0,  &
      6426225, 6464250.0, 6502275.0,  &
      6540300, 6578325.0, 6616350.0,  &
      6654375, 6692400.0, 6730425.0,  &
      6768450, 6806475.0, 6844500.0,  &
      6882525, 6920550.0, 6958575.0,  &
      6996600, 7034625.0, 7072650.0,  &
      7110675, 7148700.0, 7186725.0,  &
      7224750, 7262775.0, 7300800.0,  &
      7338825, 7376850.0, 7414875.0,  &
      7452900, 7490925.0, 7528950.0,  &
      7566975, 7605000.0, 7643025.0,  &
      7681050, 7719075.0, 7757100.0,  &
      7795125, 7833150.0, 7871175.0,  &
      7909200, 7947225.0, 7985250.0,  &
      8023275, 8061300.0, 8099325.0,  &
      8137350, 8175375.0, 8213400.0,  &
      8251425, 8289450.0, 8327475.0,  &
      8365500, 8403525.0, 8441550.0,  &
      8479575, 8517600.0, 8555625.0,  &
      8593650, 8631675.0, 8669700.0,  &
      8707725, 8745750.0, 8783775.0,  &
      8821800, 8859825.0, 8897850.0,  &
      8935875, 8973900.0, 9011925.0,  &
      9049950, 9087975.0, 9126000.0,  &
      9164025, 9202050.0, 9240075.0,  &
      9278100, 9316125.0, 9354150.0,  &
      9392175, 9430200.0, 9468225.0,  &
      9506250, 9544275.0, 9582300.0,  &
      9620325, 9658350.0, 9696375.0,  &
      9734400, 9772425.0, 9810450.0,  &
      9848475, 9886500.0, 9924525.0,  &
      9962550, 10000575.0, 10038600.0,  &
      10076625, 10114650.0, 10152675.0,  &
      10190700, 10228725.0, 10266750.0,  &
      10304775, 10342800.0, 10380825.0,  &
      10418850, 10456875.0, 10494900.0,  &
      10532925, 10570950.0, 10608975.0,  &
      10647000, 10685025.0, 10723050.0,  &
      10761075, 10799100.0, 10837125.0,  &
      10875150, 10913175.0, 10951200.0,  &
      10989225, 11027250.0, 11065275.0,  &
      11103300, 11141325.0, 11179350.0,  &
      11217375, 11255400.0, 11293425.0,  &
      11331450, 11369475.0, 11407500.0,  &
      11445525, 11483550.0, 11521575.0,  &
      11559600, 11597625.0, 11635650.0,  &
      11673675, 11711700.0, 11749725.0,  &
      11787750, 11825775.0, 11863800.0,  &
      11901825, 11939850.0, 11977875.0,  &
      12015900, 12053925.0, 12091950.0,  &
      12129975, 12168000.0, 12206025.0,  &
      12244050, 12282075.0, 12320100.0,  &
      12358125, 12396150.0, 12434175.0,  &
      12472200, 12510225.0, 12548250.0,  &
      12586275, 12624300.0, 12662325.0,  &
      12700350, 12738375.0, 12776400.0,  &
      12814425, 12852450.0, 12890475.0,  &
      12928500, 12966525.0, 13004550.0,  &
      13042575, 13080600.0, 13118625.0,  &
      13156650, 13194675.0, 13232700.0,  &
      13270725, 13308750.0, 13346775.0,  &
      13384800, 13422825.0, 13460850.0,  &
      13498875, 13536900.0, 13574925.0,  &
      13612950, 13650975.0, 13689000.0,  &
      13727025, 13765050.0, 13803075.0,  &
      13841100, 13879125.0, 13917150.0,  &
      13955175, 13993200.0, 14031225.0,  &
      14069250, 14107275.0, 14145300.0,  &
      14183325, 14221350.0, 14259375.0,  &
      14297400, 14335425.0, 14373450.0,  &
      14411475, 14449500.0, 14487525.0,  &
      14525550, 14563575.0, 14601600.0,  &
      14639625, 14677650.0, 14715675.0,  &
  ! test 645-1418
      38025, 0.0, 76050.0,  &
      0, 114075.0, 0.0,  &
      152100, 0.0, 190125.0,  &
      0, 228150.0, 0.0,  &
      266175, 0.0, 304200.0,  &
      0, 342225.0, 0.0,  &
      380250, 0.0, 418275.0,  &
      0, 456300.0, 0.0,  &
      494325, 0.0, 532350.0,  &
      0, 570375.0, 0.0,  &
      608400, 0.0, 646425.0,  &
      0, 684450.0, 0.0,  &
      722475, 0.0, 760500.0,  &
      0, 798525.0, 0.0,  &
      836550, 0.0, 874575.0,  &
      0, 912600.0, 0.0,  &
      950625, 0.0, 988650.0,  &
      0, 1026675.0, 0.0,  &
      1064700, 0.0, 1102725.0,  &
      0, 1140750.0, 0.0,  &
      1178775, 0.0, 1216800.0,  &
      0, 1254825.0, 0.0,  &
      1292850, 0.0, 1330875.0,  &
      0, 1368900.0, 0.0,  &
      1406925, 0.0, 1444950.0,  &
      0, 1482975.0, 0.0,  &
      1521000, 0.0, 1559025.0,  &
      0, 1597050.0, 0.0,  &
      1635075, 0.0, 1673100.0,  &
      0, 1711125.0, 0.0,  &
      1749150, 0.0, 1787175.0,  &
      0, 1825200.0, 0.0,  &
      1863225, 0.0, 1901250.0,  &
      0, 1939275.0, 0.0,  &
      1977300, 0.0, 2015325.0,  &
      0, 2053350.0, 0.0,  &
      2091375, 0.0, 2129400.0,  &
      0, 2167425.0, 0.0,  &
      2205450, 0.0, 2243475.0,  &
      0, 2281500.0, 0.0,  &
      2319525, 0.0, 2357550.0,  &
      0, 2395575.0, 0.0,  &
      2433600, 0.0, 2471625.0,  &
      0, 2509650.0, 0.0,  &
      2547675, 0.0, 2585700.0,  &
      0, 2623725.0, 0.0,  &
      2661750, 0.0, 2699775.0,  &
      0, 2737800.0, 0.0,  &
      2775825, 0.0, 2813850.0,  &
      0, 2851875.0, 0.0,  &
      2889900, 0.0, 2927925.0,  &
      0, 2965950.0, 0.0,  &
      3003975, 0.0, 3042000.0,  &
      0, 3080025.0, 0.0,  &
      3118050, 0.0, 3156075.0,  &
      0, 3194100.0, 0.0,  &
      3232125, 0.0, 3270150.0,  &
      0, 3308175.0, 0.0,  &
      3346200, 0.0, 3384225.0,  &
      0, 3422250.0, 0.0,  &
      3460275, 0.0, 3498300.0,  &
      0, 3536325.0, 0.0,  &
      3574350, 0.0, 3612375.0,  &
      0, 3650400.0, 0.0,  &
      3688425, 0.0, 3726450.0,  &
      0, 3764475.0, 0.0,  &
      3802500, 0.0, 3840525.0,  &
      0, 3878550.0, 0.0,  &
      3916575, 0.0, 3954600.0,  &
      0, 3992625.0, 0.0,  &
      4030650, 0.0, 4068675.0,  &
      0, 4106700.0, 0.0,  &
      4144725, 0.0, 4182750.0,  &
      0, 4220775.0, 0.0,  &
      4258800, 0.0, 4296825.0,  &
      0, 4334850.0, 0.0,  &
      4372875, 0.0, 4410900.0,  &
      0, 4448925.0, 0.0,  &
      4486950, 0.0, 4524975.0,  &
      0, 4563000.0, 0.0,  &
      4601025, 0.0, 4639050.0,  &
      0, 4677075.0, 0.0,  &
      4715100, 0.0, 4753125.0,  &
      0, 4791150.0, 0.0,  &
      4829175, 0.0, 4867200.0,  &
      0, 4905225.0, 0.0,  &
      4943250, 0.0, 4981275.0,  &
      0, 5019300.0, 0.0,  &
      5057325, 0.0, 5095350.0,  &
      0, 5133375.0, 0.0,  &
      5171400, 0.0, 5209425.0,  &
      0, 5247450.0, 0.0,  &
      5285475, 0.0, 5323500.0,  &
      0, 5361525.0, 0.0,  &
      5399550, 0.0, 5437575.0,  &
      0, 5475600.0, 0.0,  &
      5513625, 0.0, 5551650.0,  &
      0, 5589675.0, 0.0,  &
      5627700, 0.0, 5665725.0,  &
      0, 5703750.0, 0.0,  &
      5741775, 0.0, 5779800.0,  &
      0, 5817825.0, 0.0,  &
      5855850, 0.0, 5893875.0,  &
      0, 5931900.0, 0.0,  &
      5969925, 0.0, 6007950.0,  &
      0, 6045975.0, 0.0,  &
      6084000, 0.0, 6122025.0,  &
      0, 6160050.0, 0.0,  &
      6198075, 0.0, 6236100.0,  &
      0, 6274125.0, 0.0,  &
      6312150, 0.0, 6350175.0,  &
      0, 6388200.0, 0.0,  &
      6426225, 0.0, 6464250.0,  &
      0, 6502275.0, 0.0,  &
      6540300, 0.0, 6578325.0,  &
      0, 6616350.0, 0.0,  &
      6654375, 0.0, 6692400.0,  &
      0, 6730425.0, 0.0,  &
      6768450, 0.0, 6806475.0,  &
      0, 6844500.0, 0.0,  &
      6882525, 0.0, 6920550.0,  &
      0, 6958575.0, 0.0,  &
      6996600, 0.0, 7034625.0,  &
      0, 7072650.0, 0.0,  &
      7110675, 0.0, 7148700.0,  &
      0, 7186725.0, 0.0,  &
      7224750, 0.0, 7262775.0,  &
      0, 7300800.0, 0.0,  &
      7338825, 0.0, 7376850.0,  &
      0, 7414875.0, 0.0,  &
      7452900, 0.0, 7490925.0,  &
      0, 7528950.0, 0.0,  &
      7566975, 0.0, 7605000.0,  &
      0, 7643025.0, 0.0,  &
      7681050, 0.0, 7719075.0,  &
      0, 7757100.0, 0.0,  &
      7795125, 0.0, 7833150.0,  &
      0, 7871175.0, 0.0,  &
      7909200, 0.0, 7947225.0,  &
      0, 7985250.0, 0.0,  &
      8023275, 0.0, 8061300.0,  &
      0, 8099325.0, 0.0,  &
      8137350, 0.0, 8175375.0,  &
      0, 8213400.0, 0.0,  &
      8251425, 0.0, 8289450.0,  &
      0, 8327475.0, 0.0,  &
      8365500, 0.0, 8403525.0,  &
      0, 8441550.0, 0.0,  &
      8479575, 0.0, 8517600.0,  &
      0, 8555625.0, 0.0,  &
      8593650, 0.0, 8631675.0,  &
      0, 8669700.0, 0.0,  &
      8707725, 0.0, 8745750.0,  &
      0, 8783775.0, 0.0,  &
      8821800, 0.0, 8859825.0,  &
      0, 8897850.0, 0.0,  &
      8935875, 0.0, 8973900.0,  &
      0, 9011925.0, 0.0,  &
      9049950, 0.0, 9087975.0,  &
      0, 9126000.0, 0.0,  &
      9164025, 0.0, 9202050.0,  &
      0, 9240075.0, 0.0,  &
      9278100, 0.0, 9316125.0,  &
      0, 9354150.0, 0.0,  &
      9392175, 0.0, 9430200.0,  &
      0, 9468225.0, 0.0,  &
      9506250, 0.0, 9544275.0,  &
      0, 9582300.0, 0.0,  &
      9620325, 0.0, 9658350.0,  &
      0, 9696375.0, 0.0,  &
      9734400, 0.0, 9772425.0,  &
      0, 9810450.0, 0.0,  &
      9848475, 0.0, 9886500.0,  &
      0, 9924525.0, 0.0,  &
      9962550, 0.0, 10000575.0,  &
      0, 10038600.0, 0.0,  &
      10076625, 0.0, 10114650.0,  &
      0, 10152675.0, 0.0,  &
      10190700, 0.0, 10228725.0,  &
      0, 10266750.0, 0.0,  &
      10304775, 0.0, 10342800.0,  &
      0, 10380825.0, 0.0,  &
      10418850, 0.0, 10456875.0,  &
      0, 10494900.0, 0.0,  &
      10532925, 0.0, 10570950.0,  &
      0, 10608975.0, 0.0,  &
      10647000, 0.0, 10685025.0,  &
      0, 10723050.0, 0.0,  &
      10761075, 0.0, 10799100.0,  &
      0, 10837125.0, 0.0,  &
      10875150, 0.0, 10913175.0,  &
      0, 10951200.0, 0.0,  &
      10989225, 0.0, 11027250.0,  &
      0, 11065275.0, 0.0,  &
      11103300, 0.0, 11141325.0,  &
      0, 11179350.0, 0.0,  &
      11217375, 0.0, 11255400.0,  &
      0, 11293425.0, 0.0,  &
      11331450, 0.0, 11369475.0,  &
      0, 11407500.0, 0.0,  &
      11445525, 0.0, 11483550.0,  &
      0, 11521575.0, 0.0,  &
      11559600, 0.0, 11597625.0,  &
      0, 11635650.0, 0.0,  &
      11673675, 0.0, 11711700.0,  &
      0, 11749725.0, 0.0,  &
      11787750, 0.0, 11825775.0,  &
      0, 11863800.0, 0.0,  &
      11901825, 0.0, 11939850.0,  &
      0, 11977875.0, 0.0,  &
      12015900, 0.0, 12053925.0,  &
      0, 12091950.0, 0.0,  &
      12129975, 0.0, 12168000.0,  &
      0, 12206025.0, 0.0,  &
      12244050, 0.0, 12282075.0,  &
      0, 12320100.0, 0.0,  &
      12358125, 0.0, 12396150.0,  &
      0, 12434175.0, 0.0,  &
      12472200, 0.0, 12510225.0,  &
      0, 12548250.0, 0.0,  &
      12586275, 0.0, 12624300.0,  &
      0, 12662325.0, 0.0,  &
      12700350, 0.0, 12738375.0,  &
      0, 12776400.0, 0.0,  &
      12814425, 0.0, 12852450.0,  &
      0, 12890475.0, 0.0,  &
      12928500, 0.0, 12966525.0,  &
      0, 13004550.0, 0.0,  &
      13042575, 0.0, 13080600.0,  &
      0, 13118625.0, 0.0,  &
      13156650, 0.0, 13194675.0,  &
      0, 13232700.0, 0.0,  &
      13270725, 0.0, 13308750.0,  &
      0, 13346775.0, 0.0,  &
      13384800, 0.0, 13422825.0,  &
      0, 13460850.0, 0.0,  &
      13498875, 0.0, 13536900.0,  &
      0, 13574925.0, 0.0,  &
      13612950, 0.0, 13650975.0,  &
      0, 13689000.0, 0.0,  &
      13727025, 0.0, 13765050.0,  &
      0, 13803075.0, 0.0,  &
      13841100, 0.0, 13879125.0,  &
      0, 13917150.0, 0.0,  &
      13955175, 0.0, 13993200.0,  &
      0, 14031225.0, 0.0,  &
      14069250, 0.0, 14107275.0,  &
      0, 14145300.0, 0.0,  &
      14183325, 0.0, 14221350.0,  &
      0, 14259375.0, 0.0,  &
      14297400, 0.0, 14335425.0,  &
      0, 14373450.0, 0.0,  &
      14411475, 0.0, 14449500.0,  &
      0, 14487525.0, 0.0,  &
      14525550, 0.0, 14563575.0,  &
      0, 14601600.0, 0.0,  &
      14639625, 0.0, 14677650.0,  &
      0, 14715675.0, 0.0 /
  
  
  ! tests 1-4
  arr3=0
  arr3 = matmul(arr1,arr2)
  call assign_result(1,4,arr3,results)
  !print *,arr3
  
  ! tests 5-8
  arr3=0
  arr3(2:4) = matmul(arr1,arr2(:, 2:4))
  call assign_result(5,8,arr3,results)
  !print *,arr3
  
  ! tests 9-12
  arr3=0
  arr3(1:3) = matmul(arr1,arr2(:,2:4))
  call assign_result(9,12,arr3,results)
  !print *,arr3
  
  !tests 13-16
  arr3=0
  arr3(2:4) = matmul(arr1,arr2(:, 1:3))
  call assign_result(13,16,arr3,results)
  !print *,arr3
  
  !tests 17-20
  arr3=0
  arr3(2:4) = matmul(arr1(1:2),arr2(1:2,2:4))
  call assign_result(17,20,arr3,results)
  !print *,arr3
  
  !tests 21-24
  arr3=0
  arr3 = matmul(arr1(1:2),arr2(2:3,:))
  call assign_result(21,24,arr3,results)
  !print *,arr3
  
  !tests 25-28
  arr3=0
  arr3 = matmul(arr1(2:3),arr2(1:2,:))
  call assign_result(25,28,arr3,results)
  !print *,arr3
  
  !tests 29-32
  arr3=0
  arr3(2:4)  = matmul(arr1(2:3),arr2(1:2,1:3))
  call assign_result(29,32,arr3,results)
  !print *,arr3
  
  !tests 33-36
  arr3=0
  arr3(1:3)  = matmul(arr1(1:2),arr2(2:3,2:4))
  call assign_result(33,36,arr3,results)
  !print *,arr3
  
  !tests 37-40
  arr3=0
  arr3(1:3) = matmul(arr1(1:3:2),arr2(1:3:2,2:4))
  call assign_result(37,40,arr3,results)
  !print *,arr3
  
  !tests 41-44
  arr3=0
  arr3(2:4:2)  = matmul(arr1(2:3),arr2(1:2,1:3:2))
  call assign_result(41,44,arr3,results)
  !print *,arr3
  
  !tests 45-48
  arr3=0
  arr3(1:3:2)  = matmul(arr1(1:2),arr2(2:3,2:4:2))
  call assign_result(45,48,arr3,results)
  !print *,arr3
  
  !tests 49-64
  arr4=0
  arr4(2,1:3:2)  = matmul(arr1(1:2),arr2(2:3,2:4:2))
  call assign_result(49,64,arr4,results)
  !print *,arr4
  
  !tests 65-80
  arr4=0
  arr4(1:3:2,3)  = matmul(arr1(1:2),arr2(2:3,2:4:2))
  call assign_result(65,80,arr4,results)
  !print *,arr4
  
  !tests 81-96
  arr7=0
  arr7(0,0:2:2)  = matmul(arr6(-3:-2),arr5(1:3:2,0:1))
  call assign_result(81,96,arr7,results)
  !print *,arr7
  
  !tests 97-112
  arr7=0
  arr7(-1:1:2,2)  = matmul(arr6(-2:-1),arr5(1:3:2,0:1))
  call assign_result(97,112,arr7,results)
  !print *,arr7
  
  !tests 113-116
  arr3=0
  arr3(3:1:-1) = matmul(arr1(3:1:-2),arr2(1:3:2,2:4))
  call assign_result(113,116,arr3,results)
  !print *,arr3
  
  !tests 117-120
  arr3=0
  arr3(4:2:-2)  = matmul(arr1(3:2:-1),arr2(1:2,3:1:-2))
  call assign_result(117,120,arr3,results)
  !print *,arr3
  
  !tests 121-136
  arr4=0
  arr4(2,3:1:-2)  = matmul(arr1(1:2),arr2(3:2:-1,4:2:-2))
  call assign_result(121,136,arr4,results)
  !print *,arr4
  
  !tests 137-152
  arr4=0
  arr4(3:1:-2,3)  = matmul(arr1(2:1:-1),arr2(3:2:-1,2:4:2))
  call assign_result(137,152,arr4,results)
  !print *,arr4
  
  !tests 153-168
  arr7=0
  arr7(0,2:0:-2)  = matmul(arr6(-3:-2),arr5(1:3:2,0:1))
  call assign_result(153,168,arr7,results)
  !print *,arr7
  
  !tests 169-184
  arr7=0
  arr7(1:-1:-2,2)  = matmul(arr6(-1:-2:-1),arr5(3:1:-2,0:1))
  call assign_result(169,184,arr7,results)
  !print *,arr7
  
  arr12 = 0

  ! tests 185-188
  arr10=0
  arr10 = arr12 + matmul(arr8,arr9)
  call assign_result(185,188,arr10,results)
  !print *,arr10

  ! tests 189-192
  arr10=0
  arr10 = arr12 +  matmul(arr8,arr11)
  call assign_result(189,192,arr10,results)
  !print *,arr10

  ! tests 193-196
  arr10=0
  arr10(1:3) = arr12(1:3)  + matmul(arr8,arr9(:,2:4))
  call assign_result(193,196,arr10,results)
  !print *,arr10
  
  !tests 197-200
  arr10=0 
  arr10(2:4) = arr12(2:4) + matmul(arr8,arr9(:, 1:3))
  call assign_result(197,200,arr10,results)
  !print *,arr10
  
  !tests 201-204
  arr10=0 
  arr10(2:4) = arr12(2:4) + matmul(arr8(1:2),arr9(2:3,2:4))
  call assign_result(201,204,arr10,results)
  !print *,arr10
  
  !tests 205-208
  arr10=0 
  arr10 = arr12 + matmul(arr8(1:2),arr9(3:4,:))
  call assign_result(205,208,arr10,results)
  !print *,arr10

  !tests 209-212
  arr10=0
  arr10 = arr12 + matmul(arr8(2:3),arr9(2:3,:))
  call assign_result(209,212,arr10,results)
  !print *,arr10

  !tests 213-216
  arr10=0
  arr10(2:4)  = arr12(2:4) + matmul(arr8(2:3),arr9(2:3,1:3))
  call assign_result(213,216,arr10,results)
  !print *,arr10

  !tests 217-220
  arr10=0
  arr10(1:3)  = arr12(1:3) + matmul(arr8(1:2),arr9(3:4,2:4))
  call assign_result(217,220,arr10,results)
  !print *,arr10

  !tests 221-224
  arr10=0
  arr10(1:3) = arr12(1:3) + matmul(arr8(1:3:2),arr9(2:4:2,2:4))
  call assign_result(221,224,arr10,results)
  !print *,arr10

   do i = 1,11
     m2 = mod(i,2)
     if (m2 .eq. 0 ) then
         arr13(i) = 0
     else
         arr13(i) = i
     endif
     do j = 1,11
         arr14(i,j) = j;
     enddo
  enddo

  ! test 225-235
  arr20=0
  arr20 = matmul(arr13,arr14)
  call assign_result(225,235,arr20,results)
  !print *,"test 225,235"
  !print *,arr20

  ! test 236-257
  arr15=0
  arr15(1,:) = matmul(arr13,arr14)
  call assign_result(236,257,arr15,results)
  !print *,"test 236,257"
  !print *,arr15

   do i = 1,389
     m2 = mod(i,2)
     if (m2 .eq. 0 ) then
         arr16(i) = 0
     else
         arr16(i) = i
     endif
     do j = 1,387
         arr17(i,j) = j
     enddo
  enddo

  ! test 258-644
  arr18=0
  arr18 = matmul(arr16,arr17)
  call assign_result(258,644,arr18,results)
  !print *,"test 258,644"
  !print *,arr18

  ! test 645-1418
  arr19=0
  arr19(1,:) = matmul(arr16,arr17)
  call assign_result(645,1418,arr19,results)
  !print *,"test 645,1418"
  !print *,arr19
  call check(results, expect, NbrTests)

end program

subroutine assign_result(s_idx, e_idx , arr, rslt)
  integer*4, dimension(1:e_idx-s_idx+1) :: arr
  integer*4, dimension(e_idx) :: rslt
  integer:: s_idx, e_idx

  rslt(s_idx:e_idx) = arr

end subroutine

