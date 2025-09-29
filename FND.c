#include <stdint.h>

typedef struct{
    uint32_t CR;
    uint32_t FDR;
} FND_TypeDef;

#define APB_BASE 0x10000000

#define GPO_BASE (APB_BASE + 0x1000)
#define GPO_CR   *(uint32_t *)(GPO_BASE + 0x00)
#define GPO_ODR  *(uint32_t *)(GPO_BASE + 0x04)

#define GPI_BASE (APB_BASE + 0x2000)
#define GPI_CR   *(uint32_t *)(GPI_BASE + 0x00)
#define GPI_IDR  *(uint32_t *)(GPI_BASE + 0x04)

#define GPIO_BASE (APB_BASE + 0x3000)
#define GPIO_CR   *(uint32_t *)(GPIO_BASE + 0x00)
#define GPIO_IDR  *(uint32_t *)(GPIO_BASE + 0x04)
#define GPIO_ODR  *(uint32_t *)(GPIO_BASE + 0x08)

#define FND_BASE (APB_BASE + 0x4000)
#define FND_FDR   *(uint32_t *)(FND_BASE + 0x00)
#define FND_CR    *(uint32_t *)(FND_BASE + 0x04)
#define FND      ((FND_TypeDef *)(FND_BASE))

void delay(uint32_t t);
void FND_Init(FND_TypeDef *fnd);
void FND_WriteData(FND_TypeDef *fnd, uint32_t data);

int main()
{
    
    FND_Init(FND);
    uint32_t data = 0;

    while (1)
    {
        FND_WriteData(FND,data);
        data++;
        delay(1000);
    }

    return 0;
}

void FND_Init(FND_TypeDef *fnd)
{
    fnd->CR = 0x01;
}

void FND_WriteData(FND_TypeDef *fnd, uint32_t data)
{
    fnd->FDR = data;
}

void delay(uint32_t t)
{
    for(uint32_t i = 0; i < t; i++){
        for(uint32_t j=0;j<1000;j++);
    }
}
