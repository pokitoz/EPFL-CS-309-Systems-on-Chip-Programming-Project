#ifndef __LEPTON_REGS_H__
#define __LEPTON_REGS_H__

#define LEPTON_REGS_COMMAND_OFST         (0x0000)
#define LEPTON_REGS_STATUS_OFST          (0x0002)
#define LEPTON_REGS_MIN_OFST             (0x0004)
#define LEPTON_REGS_MAX_OFST             (0x0006)
#define LEPTON_REGS_SUM_LSB_OFST         (0x0008)
#define LEPTON_REGS_SUM_MSB_OFST         (0x000a)
#define LEPTON_REGS_ROW_IDX_OFST         (0x000b)
#define LEPTON_REGS_BUFFER_OFST          (0x0010)
#define LEPTON_REGS_ADJUSTED_BUFFER_OFST (0x4000)
#define LEPTON_REGS_BUFFER_SIZE          (80 * 60)
#define LEPTON_REGS_BUFFER_BYTELENGTH    (LEPTON_REGS_BUFFER_SIZE * 2)

#endif
